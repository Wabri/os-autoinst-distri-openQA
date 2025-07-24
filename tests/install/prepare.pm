use Mojo::File qw(path);
use Mojo::Base 'openQAcoretest';
use testapi;
use utils qw(login disable_packagekit switch_to_root_console);

sub run {
    login;

    # SELinux: allow web proxy to connect to openQA backend
    assert_script_run('semanage boolean -m -1 httpd_can_network_connect');

    disable_packagekit;
    assert_script_run('for i in {1..7}; do zypper --no-cd -n in retry neofetch && break; sleep $((i**2*20)); done');
    assert_script_run('zypper --no-cd -n rm xscreensaver');
    assert_script_run('pkill -f xscreensaver');
    assert_script_run("rpm -qa > sut_packages.txt");
    my $fname = upload_logs("sut_packages.txt");
    path("ulogs/$fname")->move_to("sut_packages.txt");
}

1;
