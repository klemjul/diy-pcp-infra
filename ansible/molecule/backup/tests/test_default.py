import os
import pytest

def test_packages_installed(host):
    for pkg in ["cron", "restic"]:
        p = host.package(pkg)
        assert p.is_installed

def test_directories_exist(host):
    dirs = [
        "/root/.config/restic/",
        "/opt/scripts/backups",
        "/var/log/backups/",
        "/var/lib/metrics_task_times",
    ]
    modes = ["o750", "o750", "o755", "o755"]

    for path, mode in zip(dirs, modes):
        d = host.file(path)
        assert d.exists
        assert d.is_directory
        assert oct(d.mode)[-4:] == mode
        assert d.user == "root"
        assert d.group == "root"

def test_restic_creds_file(host):
    path = f"/root/.config/restic/restic_consul.creds"
    f = host.file(path)
    assert f.exists
    assert f.is_file
    assert oct(f.mode)[-3:] == "700"
    assert f.user == "root"
    assert f.group == "root"

    content = f.content_string

    assert "AWS_DEFAULT_REGION=\"backup_s3_aws_region\"" in content
    assert "RESTIC_REPOSITORY=\"backup_s3_uri\"" in content
    assert "AWS_ACCESS_KEY_ID=\"backup_s3_key\"" in content
    assert "AWS_SECRET_ACCESS_KEY=\"backup_s3_secret_key\"" in content
    assert "RESTIC_PASSWORD=\"backup_restic_secret_password\"" in content

def test_backup_script_file(host):
    path = f"/opt/scripts/backups/backup_consul.sh"
    f = host.file(path)
    assert f.exists
    assert f.is_file
    assert oct(f.mode)[-3:] == "750"
    assert f.user == "root"
    assert f.group == "root"

def test_cron_file(host):
    path = f"/etc/cron.d/backup_consul"
    f = host.file(path)
    assert f.exists
    assert f.is_file
    assert oct(f.mode)[-3:] == "750"
    assert f.user == "root"
    assert f.group == "root"