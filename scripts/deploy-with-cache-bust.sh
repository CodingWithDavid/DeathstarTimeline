#!/bin/bash

# Azure Static Web Apps Deployment Script with Cache Busting
# Run this script after deploying to Azure Static Web Apps

echo "Starting cache invalidation process..."

# Get the current timestamp for versioning
TIMESTAMP=$(date +%s)

echo "Build timestamp: $TIMESTAMP"

# Update index.html with new timestamp
sed -i "s/Date\.now()/$TIMESTAMP/g" wwwroot/index.html

echo "Updated index.html with timestamp: $TIMESTAMP"

# Optional: If you have Azure CLI configured, you can also trigger a cache purge
# az staticwebapp show --name your-static-web-app-name --resource-group your-resource-group

echo "Cache invalidation process completed!"
echo ""
echo "Additional manual steps you can take:"
echo "1. Clear browser cache (Ctrl+Shift+R or Cmd+Shift+R)"
echo "2. Use incognito/private browsing mode to test"
echo "3. Check Azure Static Web Apps logs for deployment status"
echo "4. Verify the deployment completed successfully in Azure portal"