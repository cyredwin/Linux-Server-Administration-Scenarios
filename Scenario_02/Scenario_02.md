# Linux Server Administration — New Hire Account Automation

## Scenario

Your company has hired a new employee named **Sarah Johnson**.

As the Linux system administrator, your task is to create and configure Sarah's Linux user account.

To make the process easier for future employees, you must **automate the new-hire account creation process using a reusable Bash script**.

---

## Employee Information

| Setting                 | Requirement     |
| ----------------------- | --------------- |
| Username                | `sarah`         |
| Full Name               | `Sarah Johnson` |
| Login Shell             | `/bin/bash`     |
| Group                   | `developers`    |
| Password Maximum Age    | `90 days`       |
| Password Warning Period | `7 days`        |

---

## Requirements

Create a Bash script named:

```bash
create_new_hire.sh
```

The script should automate the creation and configuration of a new employee account.

### 1. Accept User Information

The script should accept the **username** and **full name** as arguments.

Example:

```bash
sudo ./create_new_hire.sh sarah "Sarah Johnson"
```

This makes the script reusable for future employees.

---

### 2. Create the Developers Group

Check whether the `developers` group already exists.

If it does not exist, create it.

Example command:

```bash
groupadd developers
```

---

### 3. Check Whether the User Exists

Before creating the account, verify that the username does not already exist.

The script should avoid creating a duplicate account.

---

### 4. Create the User Account

Create the user with:

* A home directory
* Full name
* `/bin/bash` as the login shell
* Membership in the `developers` group

The resulting account for Sarah should have:

```text
Username: sarah
Full Name: Sarah Johnson
Shell: /bin/bash
Group: developers
```

---

### 5. Configure Password Aging

Configure Sarah's password policy so that the password has a maximum age of **90 days**.

```bash
chage -M 90 sarah
```

---

### 6. Configure Password Expiration Warning

Sarah should receive a warning **7 days before** her password expires.

```bash
chage -W 7 sarah
```

The two settings can also be configured together:

```bash
chage -M 90 -W 7 sarah
```

---

## Expected Usage

Make the script executable:

```bash
chmod +x create_new_hire.sh
```

Run it for Sarah:

```bash
sudo ./create_new_hire.sh sarah "Sarah Johnson"
```

For another employee, the same script should be reusable.

Example:

```bash
sudo ./create_new_hire.sh john "John Smith"
```

---

## Verification

Verify Sarah's account:

```bash
id sarah
```

Check her user information:

```bash
getent passwd sarah
```

Verify the password-aging configuration:

```bash
chage -l sarah
```

The configuration should show that:

* Sarah belongs to the `developers` group.
* Her login shell is `/bin/bash`.
* Her password maximum age is **90 days**.
* Her password expiration warning period is **7 days**.

---

## Objective

The goal of this exercise is to practice Linux user and group administration while creating a reusable automation tool for onboarding new employees.

Instead of manually executing multiple commands for every new hire, the administrator should be able to create and configure an employee account with one command:

```bash
sudo ./create_new_hire.sh <username> "<Full Name>"
```
