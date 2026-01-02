# Class for setting patche policy unix server
class patching::patch_policy (
  $patch_policy = String($patching::patch_policy),) {
    #validate_string($patch_policy2)

  # Convert $patch_policy to humane readable $patch_policy_content
  # test
  case $patch_policy {
    '000000':   {$patch_policy_content = 'policy: 000000 - No patche poliy has been set!'}
    '010000':   {$patch_policy_content = 'policy: 010000 - Wednesday one week after Patch Tuesday kl 03:00'}
    '010100':   {$patch_policy_content = 'policy: 010100 - Wednesday one week after Patch Tuesday kl 07:00'}
    '010200':   {$patch_policy_content = 'policy: 010200 - Wednesday one week fater Patch Tuesday kl 11:00'}
    '020000':   {$patch_policy_content = 'policy: 020000 - Each 3. thursday kl 03:00'}
    '020100':   {$patch_policy_content = 'policy: 020100 - Each 3. saturday kl 01:00'}
    '020200':   {$patch_policy_content = 'policy: 020200 - Last wednesday in month'}
    '020300':   {$patch_policy_content = 'policy: 020300 - Last thursday in month'}
    '020400':   {$patch_policy_content = 'policy: 020400 - Each 1. monday in month kl 00:00'}
    '020401':   {$patch_policy_content = 'policy: 020401 - Each 3. monday in month kl 01:00'}
    '020402':   {$patch_policy_content = 'policy: 020402 - Each 3. monday in month kl 02:00'}
    '020500':   {$patch_policy_content = 'policy: 020500 - Each 2. torsdag in month, between 00-05'}
    '030000':   {$patch_policy_content = 'policy: 030000 - Separate agreements'}
    '030100':   {$patch_policy_content = 'policy: 030100 - Service Window'}
    '030101':   {$patch_policy_content = 'policy: 030101 - Service Window Special treatment"'}
    '040000':   {$patch_policy_content = 'policy: 040000 - No patching / or at the request of us or the customer'}
    '040200':   {$patch_policy_content = 'policy: 040200 - No patching, Restart only. Each 3. Wednesday kl 01:00'}
    '040300':   {$patch_policy_content = 'policy: 040300 - No patching, Restart only. Each 3. Wednesday kl 10:00 (daytime)"'}
    default:  {
      $patch_policy_content = "policy: Invalid parameter - ${patch_policy}"
      }
  }

  # Writeing value of $patch_policy_content to file
  if ! defined(File['/etc/patching']) {
    file {
      '/etc/patching':
        ensure => 'directory',
        mode   => '0700';
    }
  }
  file { '/etc/patching/patch_policy':
    ensure  => file,
    content => "# Managed by Puppet\n\n${patch_policy_content}\n",
    }
}
