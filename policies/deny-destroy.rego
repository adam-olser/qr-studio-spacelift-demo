# Spacelift Plan Policy.
#
# Created in the Spacelift UI (type "Plan Policy") and attached to the
# qr-studio-demo stack. This file mirrors that policy body for version
# control / reference.
#
# Effect: denies any run whose plan would delete a resource, instead of
# letting it proceed to apply.
package spacelift

deny contains sprintf("run would delete %s — destroys are not allowed by policy", [resource.address]) if {
	some resource in input.terraform.resource_changes
	some action in resource.change.actions
	action == "delete"
}
