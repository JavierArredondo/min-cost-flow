import os


def monitor(outdir, outname, log=True, plot=True):
    pid = os.getpid()
    L = ['psrecord', "%s" % pid, "--interval", "1"]
    if log:
        L = L + ["--log", "%s/log_%s_%s.txt" % (outdir, outname, pid)]
    if plot:
        L = L + ["--plot", "%s/plot_%s_%s.png" % (outdir, outname, pid)]
    if not log and not plot:
        print("Nothing being monitored")
    else:
        os.spawnvpe(os.P_NOWAIT, 'psrecord', L, os.environ)
