# GCP Billing Account Recovery & Management

## 🚨 Emergency: Lost Billing Account Access

If you cannot see your Billing Account but know it exists (e.g., invoices are arriving), follow these steps immediately.

### 1. Diagnosis: Permission vs. Deletion
Most "lost" accounts are actually just hidden due to missing IAM permissions.
*   **Symptom:** You see "You do not have permission to view this account" or the list is empty.
*   **Cause:** Your user was removed from the `Billing Account Administrator` or `Billing Account Viewer` role.

### 2. Recovery Step 1: CLI Verification
Even if the Console hides it, `gcloud` might list it if you have partial permissions.

# List all billing accounts linked to your credentials
gcloud billing accounts list

# Get details if you have the ID (format 012345-678901-ABCDEF)
gcloud billing accounts describe 0X0X0X-0X0X0X-0X0X0X### 3. Recovery Step 2: Check Organization Scope
1.  Go to **[Google Cloud Console](https://console.cloud.google.com/)**.
2.  Click the **Project Switcher** (top left).
3.  Ensure you are selecting the correct **Organization** (e.g., `your-company.com`) or "No Organization".
    *   *Billing accounts are often bound to the Organization node, not a specific project.*

### 4. Recovery Step 3: Find the Administrator
If you are not the Admin, you must find who is.
1.  Go to **Billing > Account Management**.
2.  Select "Show Info Panel" (top right).
3.  Look under **Billing Account Administrator**.
    *   *If you can't see this list, you have 0 permissions.*
    *   **Action:** Ask your Finance team, DevOps lead, or the person whose credit card is attached.

### 5. Recovery Step 4: The "Locked Out" Protocol (Google Support)
If **no one** has access (e.g., sole admin left the company):
1.  Gather Proof of Ownership:
    *   Billing Account ID (from a previous invoice/email).
    *   Last invoice number and amount.
    *   Credit Card / Bank Account details (last 4 digits).
2.  Use the **[Billing Troubleshooter](https://support.google.com/cloud/contact/billing_troubleshooter)**.
3.  Select **"I lost access to my billing account"**.
4.  Support will perform a manual verification and add your email as an Admin.

---

## 🛡️ Prevention & Governance

To prevent recurrence, implement these best practices.

### Recommended IAM Roles
*   **Billing Account Administrator:** 2-3 trusted people (CTO, Finance Lead, DevOps Lead). *Can manage payments and unlink projects.*
*   **Billing Account Viewer:** Developers or Managers who need to track spend but not change payment methods.
*   **Project Billing Manager:** Allows users to *link* projects to the billing account without seeing credit card details.

### Automation (Terraform)
Manage IAM binding via code to prevent accidental removal.

resource "google_billing_account_iam_member" "billing_admins" {
  billing_account_id = "012345-678901-ABCDEF"
  role               = "roles/billing.admin"
  member             = "group:gcp-billing-admins@yourcompany.com"
}