apt-get update
apt-get install -y python3-pip

echo "# Set up environment variables" >> /etc/bash.bashrc
echo "export GCP_PROJECT=${projectid}" >> /etc/bash.bashrc
echo "export GCP_SPANNER_INSTANCE=${spannerinstance}" >> /etc/bash.bashrc
echo "export GCP_SPANNER_DATABASE=${spannerdatabase}" >> /etc/bash.bashrc
