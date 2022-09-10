# UNMANAGED for use with scratch org

echo "Set Dev Hub"
npm run setDevHub

# Install scriptecho "Cleaning previous scratch org..."
echo "Cleaning previous scratch org..."
sfdx force:org:delete -p -u DMLOptionsOrg

echo "Clearing namespace"
sed -i "" "s|\"namespace\": \"\"|\"namespace\": \"\"|" sfdx-project.json

echo "Creating new scratch org"
sfdx force:org:create --definitionfile config/project-scratch-def.json --setalias DMLOptionsOrg --nonamespace --setdefaultusername --noancestors --durationdays 21

# For use with namespaced scratch org n package development process
echo "Deploying unmanaged main metadata"
sfdx force:source:deploy -p force-app --tracksource


# To install sample action plan template
echo "Loading sample data"
sfdx force:apex:execute -f ./data/sample-data.apex

# To install sample Flow and other metadata
echo "Deploy unmanaged extra metadata"
sfdx force:source:deploy -p force-app/unmanaged --tracksource

echo "opening org"
sfdx force:org:open