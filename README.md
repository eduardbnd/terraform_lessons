# Terraform Lessons by Eduard Bondarenko

Personal notes and command reference for learning Terraform.

## Setting AWS Credentials

### Windows PowerShell

```powershell
$env:AWS_ACCESS_KEY_ID="xxxxxxxxxxxxxxxxx"
$env:AWS_SECRET_ACCESS_KEY="yyyyyyyyyyyyyyyyyyyyyyyyyyyy"
$env:AWS_DEFAULT_REGION="zzzzzzzzz"
```

### Linux Shell

```bash
export AWS_ACCESS_KEY_ID="xxxxxxxxxxxxxxxxx"
export AWS_SECRET_ACCESS_KEY="yyyyyyyyyyyyyyyyyyyyyyyyyyyy"
export AWS_DEFAULT_REGION="zzzzzzzzz"
```

## Terraform Commands

| Command | Description |
|---|---|
| `terraform init` | Initialize the working directory |
| `terraform plan` | Preview planned changes |
| `terraform apply` | Apply changes |
| `terraform destroy` | Destroy the created infrastructure |
| `terraform show` | Show the current state |
| `terraform output` | Print output variable values |
| `terraform console` | Interactive console |
| `terraform import` | Import an existing resource into state |
| `terraform taint` | Mark a resource for recreation |

## Terraform State Commands

| Command | Description |
|---|---|
| `terraform state show` | Show attributes of a resource from state |
| `terraform state list` | List resources in state |
| `terraform state pull` | Download the current state |
| `terraform state rm` | Remove a resource from state |
| `terraform state mv` | Move/rename a resource in state |
| `terraform state push` | Push state to the backend |

Bulk move of filtered resources:

```bash
for x in $(terraform state list | grep xyz); do
  terraform state mv -state-out="terraform.tfstate" $x $x
done
```

## Terraform Workspace Commands

| Command | Description |
|---|---|
| `terraform workspace show` | Show the current workspace |
| `terraform workspace list` | List all workspaces |
| `terraform workspace new` | Create a new workspace |
| `terraform workspace select` | Switch to a workspace |
| `terraform workspace delete` | Delete a workspace |

Using the current workspace name in code:

```hcl
${terraform.workspace}
```
