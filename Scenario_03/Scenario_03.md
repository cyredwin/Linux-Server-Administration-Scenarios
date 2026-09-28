# Linux Server Administration — Managing Partitions and Linux Filesystem Automation

## Scenario

Your company is deploying a new internal web application called **CompanyPortal**.

A new **5 GB disk `/dev/sdb`** has been added to the Linux server.

As the Linux system administrator, your task is to prepare the new disk, create a filesystem, mount the storage, and configure the new web application to run from the new storage.

To make the deployment easier for future servers, you must **automate the storage and web application deployment using a reusable Bash script**.

The server must keep **SELinux enabled**, and HTTP access must be configured using **firewalld**.

---

## Server Information

| Setting | Requirement |
| ----------------------- | ------------------------- |
| New Disk | `/dev/sdb` |
| Partition | `/dev/sdb1` |
| Filesystem | `XFS` |
| Mount Point | `/webapp` |
| Web Server | `Apache HTTP Server` |
| Application | `CompanyPortal` |
| HTTP Service | `http` |
| SELinux Mode | `Enforcing` |
| SELinux Context | `httpd_sys_content_t` |
| Firewall | `firewalld` |

---

## Requirements

Create a Bash script named:

```bash
deploy_webapp.sh
```

The script should automate the configuration of the new storage and deployment of the CompanyPortal application.

---

### 1. Verify the New Disk

Verify that the new disk `/dev/sdb` exists before making any changes.

Example command:

```bash
lsblk
```

The new disk should appear as:

```text
sdb
```

The script should stop if `/dev/sdb` does not exist.

---

### 2. Create a New Partition

Use `fdisk` to create a new partition on:

```text
/dev/sdb
```

Create:

```text
/dev/sdb1
```

The partition should use the available disk space.

Example:

```bash
fdisk /dev/sdb
```

Inside `fdisk`, the administrator would normally use:

```text
n
p
1
Enter
Enter
w
```

The Bash script should automate this process.

---

### 3. Create the XFS Filesystem

Format the new partition with the **XFS filesystem**.

Example:

```bash
mkfs.xfs /dev/sdb1
```

Verify the filesystem:

```bash
lsblk -f
```

The partition should show:

```text
/dev/sdb1    xfs
```

---

### 4. Create the Application Mount Point

Create the directory:

```text
/webapp
```

Example:

```bash
mkdir -p /webapp
```

This directory will contain the new CompanyPortal application.

---

### 5. Configure Persistent Storage

Retrieve the UUID of the new partition.

Example:

```bash
blkid /dev/sdb1
```

Configure `/etc/fstab` so `/dev/sdb1` automatically mounts on `/webapp` after the server reboots.

The entry should use the partition UUID.

Example:

```text
UUID=<UUID> /webapp xfs defaults 0 0
```

Mount the filesystem:

```bash
mount /webapp
```

Verify:

```bash
findmnt /webapp
```

---

### 6. Install Apache HTTP Server

Install Apache:

```bash
dnf install -y httpd
```

Enable and start the service:

```bash
systemctl enable --now httpd
```

Verify:

```bash
systemctl status httpd
```

---

### 7. Create the CompanyPortal Application

Create the application file:

```text
/webapp/index.html
```

The page should contain:

```html
<h1>CompanyPortal Application</h1>
<p>Application running from the new storage.</p>
```

The application must run directly from the new `/webapp` filesystem.

---

### 8. Configure Apache to Use the New Storage

Configure Apache so that `/webapp` is used as the web application's document root.

Apache should serve:

```text
/webapp/index.html
```

instead of using only the default:

```text
/var/www/html
```

Verify the Apache configuration:

```bash
httpd -t
```

---

### 9. Configure SELinux

SELinux must remain enabled and in **Enforcing** mode.

Verify:

```bash
getenforce
```

Expected result:

```text
Enforcing
```

Because `/webapp` is not Apache's default web directory, configure the correct SELinux context.

Install the SELinux management tools if necessary:

```bash
dnf install -y policycoreutils-python-utils
```

Configure `/webapp` for Apache:

```bash
semanage fcontext -a -t httpd_sys_content_t "/webapp(/.*)?"
```

Apply the SELinux context:

```bash
restorecon -Rv /webapp
```

Verify:

```bash
ls -Zd /webapp
```

The directory should use:

```text
httpd_sys_content_t
```

SELinux should **not be disabled** to make the application work.

---

### 10. Configure the Firewall

Make sure `firewalld` is enabled and running.

```bash
systemctl enable --now firewalld
```

Permanently allow HTTP traffic:

```bash
firewall-cmd --permanent --add-service=http
```

Reload the firewall:

```bash
firewall-cmd --reload
```

Verify:

```bash
firewall-cmd --list-services
```

The output should include:

```text
http
```

---

### 11. Start the Web Application

Make sure Apache is enabled and running:

```bash
systemctl enable --now httpd
```

The CompanyPortal application should now be served from:

```text
/webapp
```

Test the application locally:

```bash
curl http://localhost
```

Expected result:

```html
<h1>CompanyPortal Application</h1>
<p>Application running from the new storage.</p>
```

---

## Expected Usage

Make the script executable:

```bash
chmod +x deploy_webapp.sh
```

Check the Bash syntax:

```bash
bash -n deploy_webapp.sh
```

Run the automation script:

```bash
sudo ./deploy_webapp.sh
```

If you are already logged in as `root`:

```bash
./deploy_webapp.sh
```

---

## Verification

Verify the disk and partition:

```bash
lsblk
```

Verify the filesystem:

```bash
lsblk -f
```

Verify the persistent mount:

```bash
findmnt /webapp
```

Check the `/etc/fstab` configuration:

```bash
cat /etc/fstab
```

Verify SELinux:

```bash
getenforce
```

Check the SELinux context:

```bash
ls -Zd /webapp
```

Verify Apache:

```bash
systemctl status httpd
```

Verify the firewall:

```bash
firewall-cmd --list-services
```

Test the application:

```bash
curl http://localhost
```

The final configuration should show that:

* `/dev/sdb1` was created from `/dev/sdb`.
* `/dev/sdb1` uses the `XFS` filesystem.
* The filesystem is mounted on `/webapp`.
* The mount is persistent through `/etc/fstab`.
* Apache serves the CompanyPortal application from `/webapp`.
* SELinux remains in **Enforcing** mode.
* `/webapp` uses the `httpd_sys_content_t` SELinux context.
* The `http` service is permanently allowed through `firewalld`.
* Apache starts automatically when the server boots.
* The CompanyPortal application is accessible over HTTP.

---

## Objective

The goal of this exercise is to practice **Linux storage administration, filesystem management, web server configuration, SELinux, firewall management, and Bash automation**.

Instead of manually configuring the new disk and web application, the administrator should be able to prepare the storage and deploy the application with one command:

```bash
sudo ./deploy_webapp.sh
```


> **Warning:** `fdisk` and `mkfs.xfs` can destroy existing data. Before running the automation script, verify with `lsblk` that `/dev/sdb` is the correct new disk.