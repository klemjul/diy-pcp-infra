def test_debian_user_absent(host):
  debian_user = host.user("debian")
  assert not debian_user.exists, "The 'debian' user should be absent"

def test_rkhunter_command_available(host):
    cmd = host.run("which rkhunter")
    assert cmd.rc == 0

def test_clamav_scan_command_available(host):
    cmd = host.run("which clamscan")
    assert cmd.rc == 0