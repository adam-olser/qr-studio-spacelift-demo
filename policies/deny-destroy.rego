# Spacelift Plan Policy (not Approval Policy — see git history for the
# earlier wrong attempt).
#
# Create as a new Policy in the Spacelift UI, type "Plan Policy", paste
# this body, then attach it to the qr-studio-demo stack (Stack > Policies
# tab).
#
# Effect: denies any run whose plan would delete a resource, instead of
# letting it proceed to apply.
package spacelift

deny contains sprintf("run would delete %s — destroys are not allowed by policy", [resource.address]) if {
	some resource in input.terraform.resource_changes
	some action in resource.change.actions
	action == "delete"
}
