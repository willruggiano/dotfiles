{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.programs.htop;
  fields = {
    pid = 0;
    comm = 1;
    state = 2;
    ppid = 3;
    pgrp = 4;
    session = 5;
    tty_nr = 6;
    tpgid = 7;
    minflt = 9;
    majflt = 11;
    priority = 17;
    nice = 18;
    starttime = 20;
    processor = 37;
    m_size = 38;
    m_resident = 39;
    st_uid = 45;
    percent_cpu = 46;
    percent_mem = 47;
    user = 48;
    time = 49;
    nlwp = 50;
    tgid = 51;
    percent_norm_cpu = 52;
    elapsed = 53;
    cminflt = 10;
    cmajflt = 12;
    utime = 13;
    stime = 14;
    cutime = 15;
    cstime = 16;
    m_share = 40;
    m_trs = 41;
    m_drs = 42;
    m_lrs = 43;
    m_dt = 44;
    ctid = 99;
    vpid = 100;
    vxid = 102;
    rchar = 102;
    wchar = 103;
    syscr = 104;
    syscw = 105;
    rbytes = 106;
    wbytes = 107;
    cnclwb = 108;
    io_read_rate = 109;
    io_write_rate = 110;
    io_rate = 111;
    cgroup = 112;
    oom = 113;
    io_priority = 114;
    m_pss = 118;
    m_swap = 119;
    m_psswp = 120;
  };
in {
  config = mkIf cfg.enable {
    environment.systemPackages = [cfg.package];

    programs.htop.settings = {
      fields = with fields; [
        pid
        user
        priority
        nice
        m_size
        m_resident
        m_share
        state
        percent_cpu
        percent_mem
        time
        comm
      ];
      show_program_path = true;
    };
  };
}
