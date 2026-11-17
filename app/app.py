# Minimal JSON API using only the Python standard library (no pip installs needed)
import json
import os
from http.server import BaseHTTPRequestHandler, HTTPServer

PORT = int(os.environ.get("APP_PORT", "8080"))  # Port comes from the systemd service


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/health":
            body = {"status": "ok"}
        elif self.path == "/":
            body = {"message": "Hello from EC2, deployed with Terraform!"}
        else:
            self.send_response(404)
            self.end_headers()
            return

        data = json.dumps(body).encode()
        self.send_response(200)
        self.send_header("Content-Type", "application/json")
        self.end_headers()
        self.wfile.write(data)


HTTPServer(("0.0.0.0", PORT), Handler).serve_forever()