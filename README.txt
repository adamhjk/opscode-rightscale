

* Create the Opscode Organization Credential
 Click "Design"->"Credentials"->"New Credential"
   Name: OPSCODE_ORGANIZATION
   Value: Your Organization name ("opscode", for example)
   Description: Opscode Organization Name
 Click "Save"

* Create the Opscode Validation Key Credential
 Click "Design"->"Credentials"->"New Credential"
   Name: OPSCODE_VALIDATION_KEY
   Value: Your Opscode Validation Key (paste it in!)
   Description: Our Opscode Validation Key
 Click "Save"

* Import the v5+ Multi-Cloud Images
 Click "Design"->"Library"->"MultiCloud Images"
 Click "import" next to all the Operating Systems you want to use - make sure they are v4+, and CentOS, RHEL, or Ubuntu.

* Import the RighScale Public Chef Repo
 Click "Design"->"RepoPaths"->"New"
   Name: "RightScale Public"
 Click "Cookbook Repos"
   Click "Add cookbook repo"
     URL: git://github.com/rightscale/cookbooks_public
     Type: git
     Tag/Branch: Leave empty
     Cookbooks path: cookbooks
   Click "Save"

* Create the RightScripts
  Click "Design"->"RightScripts->"New"
    Name: Connect to the Opscode Platform
    Description: Connects RightScale to the Opscode Platform
    Script: contents of rightscripts/connect_to_opscode_platform.rb

    Click "Identify"

    Set the OPSCODE_INITIAL_RUN_LIST if you want
    Set OPSCODE_NODE_NAME to Dropdown
      Env EC2_INSTANCE_ID
      Env RS_SERVER_NAME
      Env RS_INSTANCE_UUID
    Set the OPSCODE_ORGANIZATION to the CRED that matches

    Set the OPSCODE_VALIDATION_KEY to the CRED that matches

    Set RSDEPLOYMENT_NAME, RSSERVER_NAME, and RSSERVER_TEMPLATE_NAME to the ENV variables
  Click "Save"

  Click "Design"->"RightScripts->"New"
    Name: Initial Opscode Chef Run 
    Description: Runs Chef for the first time
    Script: contents of rightscripts/initial_opscode_chef_run.rb
  Click "Save"

  Click "Design"->"RightScripts->"New"
    Name: Opscode Platform Chef Run 
    Description: Runs the Opscode Platform connected Chef 
    Script: contents of rightscripts/opscode_platform_chef_run.rb
  Click "Save"

  Click "Design"->"RightScripts->"New"
    Name: Delete node from the Opscode Platform 
    Description: Deletes the node from the Opscode Platform 
    Script: contents of rightscripts/delete_node_from_opscode_platform.rb
  Click "Save"

* Create a new Server Template
 Click "Design"->"ServerTemplates"->"New"
   Name: Opscode Platform Server Base
   Description: Connect to the Opscode Platform
   MultiCloud Image: Select one of the v4+ images
 Click "Save"
 Click "Repos"
   Click the pencil
   Click "Private"->"RightScale Public [HEAD]"
 Click "Scripts"
   Under "Boot Scripts"
     Click "Add Recipe"->"rs_utils"->"rs_utils::default"
       Click "Select"
     Click "Add Script"->"Unpublished"->"Connect to Opscode Platform"
       Click "Select"
       Click the Pencil next to "Connect to Opscode Platform"
       Set the revision to HEAD
       Click the Check-mark
     Click "Add Script"->"Unpublished"->"Initial Opscode Chef Run"
       Click "Select"
       Click the Pencil next to "Initial Opscode Chef Run"
       Set the revision to HEAD
       Click the Check-mark
   Under "Operational Scripts"
     Click "Add Script"->"Unpublished->"Opscode Platform Chef Run"
       Click "Select"
       Click the Pencil next to "Opscode Platform Chef Run"
       Set the revision to HEAD
       Click the Check-mark
   Under "Decommission Scripts"
     Click "Add Script"->"Unpublished->"Delete node from the Opscode Platform"
       Click "Select"
       Click the Pencil next to "Delete node from the Opscode Platform"
       Set the revision to HEAD
       Click the Check-mark
 Click "Inputs"->"Edit"
   Set OPSCODE_NODE_NAME to env:RS_SERVER_NAME
   Set OPSCODE_ORGANIZATION to cred:OPSCODE_ORGANIZATION
   Set OPSCODE_VALIDATION_KEY to cred:OPSCODE_VALIDATION_KEY
   Set RSDEPLOYMENT_NAME to env:RS_DEPLOYMENT_NAME
   Set RSSERVER_NAME to env:RS_SERVER_NAME
   Set RSSERVER_TEMPLATE_NAME to env:RS_SERVER_TEMPLATE_NAME
   Click "Save"

