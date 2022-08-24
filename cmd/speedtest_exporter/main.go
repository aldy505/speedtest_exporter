package main

import (
	"context"
	"errors"
	"flag"
	"fmt"
	"log"
	"net/http"
	"os"
	"os/signal"
	"time"

	"github.com/danopstech/speedtest_exporter/internal/exporter"
	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

func main() {
	listenAddress := flag.String("web.listen-address", ":9090", "Address on which to expose metrics and web interface")
	metricsPath := flag.String("web.telemetry-path", "/metrics", "Path under which to expose metrics")
	serverID := flag.Int("server_id", -1, "Speedtest.net server ID to run test against, -1 will pick the closest server to your location")
	serverFallback := flag.Bool("server_fallback", false, "If the server_id given is not available, should we fallback to closest available server")
	flag.Parse()

	exporter, err := exporter.New(*serverID, *serverFallback)
	if err != nil {
		panic(err)
	}

	r := prometheus.NewRegistry()
	r.MustRegister(exporter)

	mux := http.NewServeMux()

	mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		_, _ = w.Write([]byte(`<html>
             <head><title>Speedtest Exporter</title></head>
             <body>
             <h1>Speedtest Exporter</h1>
             <p>Metrics page will take approx 40 seconds to load and show results, as the exporter carries out a speedtest when scraped.</p>
             <p><a href='` + *metricsPath + `'>Metrics</a></p>
             <p><a href='/health'>Health</a></p>
             </body>
             </html>`))
	})

	mux.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		client := http.Client{
			Timeout: 3 * time.Second,
		}
		_, err := client.Get("https://clients3.google.com/generate_204")
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			_, _ = fmt.Fprint(w, "No Internet Connection")
		} else {
			w.WriteHeader(http.StatusOK)
			_, _ = fmt.Fprint(w, "OK")
		}
	})

	mux.Handle(*metricsPath, promhttp.HandlerFor(r, promhttp.HandlerOpts{
		MaxRequestsInFlight: 1,
		Timeout:             60 * time.Second,
	}))

	server := &http.Server{
		Handler:           mux,
		Addr:              *listenAddress,
		ReadTimeout:       time.Minute * 10,
		WriteTimeout:      time.Minute * 10,
		ReadHeaderTimeout: time.Minute * 10,
	}

	exitSignal := make(chan os.Signal, 1)
	signal.Notify(exitSignal, os.Interrupt)

	go func() {
		log.Printf("Server is starting on %s", *listenAddress)

		err := server.ListenAndServe()
		if err != nil && !errors.Is(err, http.ErrServerClosed) {
			log.Fatalf("Listening to HTTP: %v", err)
		}
	}()

	<-exitSignal

	log.Printf("Recevied exit signal")

	ctx, cancel := context.WithTimeout(context.Background(), time.Second*10)
	defer cancel()

	err = server.Shutdown(ctx)
	if err != nil {
		log.Printf("Shutting down server: %v", err)
	}
}
