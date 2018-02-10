<?xml version='1.0' encoding='UTF-8'?>
<com.cloudbees.jenkins.plugins.bitbucket.endpoints.BitbucketEndpointConfiguration plugin="cloudbees-bitbucket-branch-source@2.2.8">
  <endpoints>
    <com.cloudbees.jenkins.plugins.bitbucket.endpoints.BitbucketServerEndpoint>
      <manageHooks>true</manageHooks>
      <credentialsId>${BITBUCKET_CREDENTIALS_ID}</credentialsId>
      <displayName>${BITBUCKET_NAME}</displayName>
      <serverUrl>${BITBUCKET_URL}</serverUrl>
    </com.cloudbees.jenkins.plugins.bitbucket.endpoints.BitbucketServerEndpoint>
  </endpoints>
</com.cloudbees.jenkins.plugins.bitbucket.endpoints.BitbucketEndpointConfiguration>