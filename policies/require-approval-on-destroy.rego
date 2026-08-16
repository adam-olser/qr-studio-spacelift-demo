# Spacelift Approval Policy.
#
# Not auto-attached via config — create this as a Policy resource in the
# Spacelift UI (or via the Spacelift Terraform provider), paste this body,
# and attach it to the qr-studio-demo stack (manually, or by adding the
# `autoattach:approval` label to the stack and this policy).
#
# Effect: any run whose plan deletes a resource requires manual approval
# before it can apply, instead of auto-applying.
package spacelift

reject if {
	some change in input.run.changes
	change.action == "deleted"
	change.phase == "plan"
}
