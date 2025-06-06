@description('Name of the Action Group')
param actionGroupName string

@description('List of email receivers for alerts.')
param emailReceivers array

resource actionGroup 'Microsoft.Insights/actionGroups@2023-01-01' = {
  name: actionGroupName
  location: 'Global'
  properties: {
    groupShortName: actionGroupName
    enabled: true
    emailReceivers: [
      for email in emailReceivers: {
        name: email
        emailAddress: email
        useCommonAlertSchema: true
      }
    ]
  }
}

output actionGroupId string = actionGroup.id
