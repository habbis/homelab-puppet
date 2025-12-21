# patching of unix servers
class patching (
# @param patching policy
  String  $patch_policy
) {
  contain patching::patch_policy
}
