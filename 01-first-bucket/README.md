# S3 IAM Build-Break Lab

Intentionally break an AWS S3 IAM policy, observe the failure, and troubleshoot the root cause.

terraform init
terraform apply

cd /workspace/01-first-bucket
./configure-reader.sh

## Baseline Tests

```bash
aws s3 ls s3://lab-data-bucket --profile reader
# Should list hello.txt

aws s3 cp s3://lab-data-bucket/hello.txt - --profile reader
# Should print the text

echo "x" > test.txt

aws s3 cp test.txt s3://lab-data-bucket/ --profile reader
# Should be AccessDenied

aws s3 cp s3://lab-data-bucket/hello.txt ./hello.txt --profile reader
# Should download hello.txt
```

---

## Experiments

| # | Change in `main.tf`                                                                                  | What to observe                                               |
| - | ---------------------------------------------------------------------------------------------------- | ------------------------------------------------------------- |
| 1 | Change `ListBucket` `Resource` to `"arn:aws:s3:::lab-data-buckt"`                                    | `ls` fails. Prove the failure is caused by the ARN.           |
| 2 | Change `GetObject` `Resource` to `aws_s3_bucket.data.arn` and remove `/*`                            | `ls` works but `cp` fails. Understand bucket vs. object ARNs. |
| 3 | Add a third statement with `Effect = "Deny"` and `Action = ["s3:GetObject"]` using the same resource | `GetObject` is blocked. Determine which IAM rule wins.        |
| 4 | Delete the entire `aws_iam_user_policy` block                                                        | All S3 access is denied. Identify the resulting error.        |

---

# Experiment 1 - Incorrect ListBucket ARN

### Change

```hcl
Resource = "arn:aws:s3:::lab-data-buckt"
```

### Symptom

**Exact error:**

```text
[Paste exact error here]
```

### Root Cause

[Explain why the incorrect bucket ARN caused the failure.]

### How I Found It

[Document the troubleshooting process.]

### How to Prevent It

[Document how this mistake could be prevented.]

---

# Experiment 2 - Incorrect GetObject ARN

### Change

```hcl
Resource = aws_s3_bucket.data.arn
```

Removed:

```text
/*
```

### Symptom

**Exact error:**

```text
[Paste exact error here]
```

### Root Cause

[Explain why `ListBucket` works while `GetObject` fails and why bucket and object ARNs are different.]

### How I Found It

[Document the troubleshooting process.]

### How to Prevent It

[Document how this mistake could be prevented.]

---

# Experiment 3 - Explicit Deny

### Change

Added:

```hcl
effect = "Deny"

actions = [
  "s3:GetObject"
]
```

### Symptom

**Exact error:**

```text
[Paste exact error here]
```

### Root Cause

[Explain why the explicit `Deny` overrides the `Allow`.]

### How I Found It

[Document the troubleshooting process.]

### How to Prevent It

[Document how this mistake could be prevented.]

---

# Experiment 4 - No IAM Policy

### Change

Deleted the entire:

```hcl
aws_iam_user_policy
```

block.

### Symptom

**Exact error:**

```text
[Paste exact error here]
```

### Root Cause

[Explain why the user has no permissions.]

### How I Found It

[Document the troubleshooting process.]

### How to Prevent It

[Document how this mistake could be prevented.]

---

## Reset Lab

After completing an experiment:

```bash
./reset-lab.sh
```

The reset script:

* Deletes `test.txt`
* Deletes downloaded `hello.txt`
* Restores the known-good `main.tf`
* Runs `terraform apply`

Then verify the baseline:

```bash
aws s3 ls s3://lab-data-bucket --profile reader
aws s3 cp s3://lab-data-bucket/hello.txt - --profile reader
```

---

## Troubleshooting Framework

For every failure, answer:

```text
Symptom
   ↓
Exact error
   ↓
AWS API operation
   ↓
Required IAM action
   ↓
Resource being accessed
   ↓
Resource ARN
   ↓
Allow / Deny evaluation
   ↓
Root cause
```

The objective is to learn how to **systematically troubleshoot IAM permission failures**, rather than simply memorizing the correct policy.
