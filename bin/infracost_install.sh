# Downloads the CLI based on your OS/arch and puts it in /usr/local/bin
curl -fsSL https://raw.githubusercontent.com/infracost/infracost/master/scripts/install.sh | sh

# Verify installation
echo "Infracost version: $(infracost --version)"