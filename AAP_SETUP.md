# Ansible Automation Platform Setup Guide

This guide explains how to configure and run the ServiceNow Keep-Alive playbook in Ansible Automation Platform (AAP).

## Prerequisites

- Ansible Automation Platform 2.0+ (formerly Ansible Tower)
- Project configured in AAP pointing to this repository
- ServiceNow credentials configured in AAP

## Setup Steps

### 1. Sync Project

Ensure your project is synced with the latest code from this repository.

### 2. Create Job Template

Create a new Job Template with the following settings:

- **Name**: ServiceNow Keep-Alive
- **Description**: Prevents ServiceNow dev instance hibernation
- **Job Type**: Run
- **Inventory**: localhost (or any inventory with localhost)
- **Project**: [Your project name]
- **Playbook**: snow_keep_alive.yml
- **Credentials**: [Your ServiceNow credential]
- **Verbosity**: 0 (Normal) or 1 (Verbose) for more details

### 3. Configure Survey (Optional)

If you want to make the job flexible, import the survey configuration:

1. In the Job Template, click on "Survey"
2. Import the survey from `aap_job_template_survey.json`
3. Enable the survey

The survey allows operators to specify:
- ServiceNow Instance URL
- ServiceNow Username
- ServiceNow Password
- CI System ID
- SSL Certificate Validation

### 4. Configure Variables

You can provide variables in multiple ways:

#### Option A: Using AAP Credentials (Recommended)
Variables will be injected from your ServiceNow credential type.

#### Option B: Using Extra Variables
Add to the Job Template's Extra Variables:
```yaml
snow_instance_url: "https://dev12345.service-now.com"
snow_user: "admin"
snow_pass: "{{ vault_password }}"
ci_number: "your_ci_sys_id"
validate_ssl: true
```

#### Option C: Using Survey
Enable the survey to prompt for values at runtime.

### 5. Schedule the Job

To prevent hibernation, schedule the job to run periodically:

1. In the Job Template, click on "Schedules"
2. Add a new schedule:
   - **Name**: Keep-Alive Every 12 Hours
   - **Start Date/Time**: [Current date/time]
   - **Local Time Zone**: [Your timezone]
   - **Repeat Frequency**: 12 Hours
   - **End**: Never

Alternatively, for more frequent updates:
- **Repeat Frequency**: 6 Hours

### 6. Notifications (Optional)

Configure notifications for job failures:

1. Go to Notifications in AAP
2. Create a notification template (Email, Slack, etc.)
3. Add to Job Template:
   - On Failure: [Your notification template]

## Running the Job

### Manual Execution
1. Navigate to Templates
2. Click the launch button (🚀) next to "ServiceNow Keep-Alive"
3. Fill in survey values if enabled
4. Click "Launch"

### Monitor Execution
- View real-time output in the Jobs tab
- Check for the success message showing CI update
- Review AAP job statistics for tracking

## AAP-Specific Features

The playbook includes AAP-specific enhancements:

1. **Job Tracking**: Uses `tower_job_id` and `tower_job_template_name` for logging
2. **Statistics**: Sets job statistics for AAP reporting
3. **Enhanced Logging**: Formatted output for AAP job viewer
4. **Error Handling**: Proper error messages for AAP interface

## Troubleshooting

### Job Fails with Authentication Error
- Verify ServiceNow credentials in AAP
- Check if user has permissions to update CIs
- Ensure password hasn't expired

### Job Fails with Connection Error
- Verify `snow_instance_url` is correct
- Check network connectivity from AAP to ServiceNow
- Verify SSL certificates if `validate_ssl: true`

### CI Not Found Error
- Verify the `ci_number` (sys_id) is correct
- Ensure CI exists in ServiceNow
- Check user permissions for the specific CI

### Variables Not Defined
- Ensure credentials are properly attached to job template
- Verify extra variables syntax if used
- Check survey configuration if enabled

## Best Practices for AAP

1. **Use Credentials**: Store sensitive data in AAP credentials, not in extra vars
2. **Enable Notifications**: Set up failure notifications for critical jobs
3. **Monitor Job History**: Regularly review job history for patterns
4. **Use Schedules**: Automate execution rather than manual runs
5. **Set Appropriate Verbosity**: Use verbose mode for troubleshooting
6. **Tag Your Runs**: Use job tags for easier filtering in job history
7. **Document Changes**: Update this guide when modifying the setup

## Integration with ServiceNow

For advanced integration, consider:

1. **Webhook Triggers**: Configure ServiceNow to trigger AAP jobs
2. **ServiceNow Catalog**: Add as a catalog item in ServiceNow
3. **Incident Creation**: Auto-create incidents on job failure
4. **CMDB Updates**: Track last keep-alive in CMDB

## Security Considerations

1. Use AAP's built-in RBAC to control who can run this job
2. Rotate ServiceNow passwords regularly
3. Use separate credentials for dev/test/prod instances
4. Enable audit logging in AAP
5. Consider using OAuth instead of basic auth for ServiceNow