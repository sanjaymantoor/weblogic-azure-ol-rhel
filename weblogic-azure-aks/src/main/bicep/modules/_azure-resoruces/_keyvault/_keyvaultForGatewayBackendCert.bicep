// Copyright (c) 2021, Oracle Corporation and/or its affiliates.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

@description('Secret name of certificate data.')
param certificateDataName string

@description('Certificate data to store in the secret')
param certificateDataValue string

@description('Property to specify whether Azure Resource Manager is permitted to retrieve secrets from the key vault.')
param enabledForTemplateDeployment bool = true

@description('Name of the vault')
param keyVaultName string

@description('Price tier for Key Vault.')
param sku string

param utcValue string = utcNow()

resource keyvault 'Microsoft.KeyVault/vaults@2019-09-01' = {
  name: keyVaultName
  location: resourceGroup().location
  properties: {
    enabledForTemplateDeployment: enabledForTemplateDeployment
    sku: {
      name: sku
      family: 'A'
    }
    accessPolicies: []
    tenantId: subscription().tenantId
  }
  tags:{
    'managed-by-azure-weblogic': utcValue
  }
}

resource secretForCertificate 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
  name: '${keyVaultName}/${certificateDataName}'
  properties: {
    value: certificateDataValue
  }
  dependsOn: [
    keyvault
  ]
}

output keyVaultName string = keyVaultName
output sslBackendCertDataSecretName string = certificateDataName
