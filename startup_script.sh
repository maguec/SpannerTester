apt-get update
apt-get install -y python3-pip python3-venv golang-1.23

cd /tmp
/usr/bin/curl -L https://github.com/GoogleCloudPlatform/grpc-gcp-tools/releases/latest/download/dp_check -o dp_check
chmod +x dp_check

ln -s /usr/lib/go-1.23/bin/go /usr/bin/go
echo "# Set up environment variables" >> /etc/bash.bashrc
echo "export GCP_PROJECT=${projectid}" >> /etc/bash.bashrc
echo "export GCP_SPANNER_INSTANCE=${spannerinstance}" >> /etc/bash.bashrc
echo "export GCP_SPANNER_DATABASE=${spannerdatabase}" >> /etc/bash.bashrc

