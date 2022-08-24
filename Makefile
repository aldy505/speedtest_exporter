build:
	rm -rf out
	mkdir out

	GOOS=darwin GOARCH=amd64 go build -o speedtest_exporter cmd/speedtest_exporter/main.go
	tar -czf out/speedtest_exporter-darwin-amd64.tar.gz speedtest_exporter LICENSE README.md
	rm speedtest_exporter
	sha256sum out/speedtest_exporter-darwin-amd64.tar.gz

	GOOS=darwin GOARCH=arm64 go build -o speedtest_exporter cmd/speedtest_exporter/main.go
	tar -czf out/speedtest_exporter-darwin-arm64.tar.gz speedtest_exporter LICENSE README.md
	rm speedtest_exporter
	sha256sum out/speedtest_exporter-darwin-arm64.tar.gz

	GOOS=linux GOARCH=386 go build -o speedtest_exporter cmd/speedtest_exporter/main.go
	tar -czf out/speedtest_exporter-linux-386.tar.gz speedtest_exporter LICENSE README.md
	rm speedtest_exporter
	sha256sum out/speedtest_exporter-linux-386.tar.gz

	GOOS=linux GOARCH=amd64 go build -o speedtest_exporter cmd/speedtest_exporter/main.go
	tar -czf out/speedtest_exporter-linux-amd64.tar.gz speedtest_exporter LICENSE README.md
	rm speedtest_exporter
	sha256sum out/speedtest_exporter-linux-amd64.tar.gz

	GOOS=linux GOARCH=arm go build -o speedtest_exporter cmd/speedtest_exporter/main.go
	tar -czf out/speedtest_exporter-linux-arm.tar.gz speedtest_exporter LICENSE README.md
	rm speedtest_exporter
	sha256sum out/speedtest_exporter-linux-arm.tar.gz

	GOOS=linux GOARCH=arm64 go build -o speedtest_exporter cmd/speedtest_exporter/main.go
	tar -czf out/speedtest_exporter-linux-arm64.tar.gz speedtest_exporter LICENSE README.md
	rm speedtest_exporter
	sha256sum out/speedtest_exporter-linux-arm64.tar.gz

	GOOS=windows GOARCH=386 go build -o speedtest_exporter.exe cmd/speedtest_exporter/main.go
	zip out/speedtest_exporter-windows-386.zip speedtest_exporter.exe LICENSE README.md
	rm speedtest_exporter.exe
	sha256sum out/speedtest_exporter-windows-386.zip

	GOOS=windows GOARCH=amd64 go build -o speedtest_exporter.exe cmd/speedtest_exporter/main.go
	zip out/speedtest_exporter-windows-amd64.zip speedtest_exporter.exe LICENSE README.md
	rm speedtest_exporter.exe
	sha256sum out/speedtest_exporter-windows-amd64.zip
	
	GOOS=windows GOARCH=arm go build -o speedtest_exporter.exe cmd/speedtest_exporter/main.go
	zip out/speedtest_exporter-windows-arm.zip speedtest_exporter.exe LICENSE README.md
	rm speedtest_exporter.exe
	sha256sum out/speedtest_exporter-windows-arm.zip