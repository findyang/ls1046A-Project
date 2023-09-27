cmd_drivers/net/wireless/ralink/rt2x00/rt2x00config.o := aarch64-linux-gnu-gcc -Wp,-MD,drivers/net/wireless/ralink/rt2x00/.rt2x00config.o.d  -nostdinc -isystem /usr/lib/gcc-cross/aarch64-linux-gnu/7/include -I/home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include -I./arch/arm64/include/generated  -I/home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include -I./include -I/home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/uapi -I./arch/arm64/include/generated/uapi -I/home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi -I./include/generated/uapi -include /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/kconfig.h  -I/home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/drivers/net/wireless/ralink/rt2x00 -Idrivers/net/wireless/ralink/rt2x00 -D__KERNEL__ -mlittle-endian -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -fshort-wchar -Werror-implicit-function-declaration -Wno-format-security -std=gnu89 -fno-PIE -mgeneral-regs-only -DCONFIG_AS_LSE=1 -fno-asynchronous-unwind-tables -mpc-relative-literal-loads -mabi=lp64 -fno-delete-null-pointer-checks -Wno-frame-address -Wno-format-truncation -Wno-format-overflow -Wno-int-in-bool-context -O2 --param=allow-store-data-races=0 -DCC_HAVE_ASM_GOTO -Wframe-larger-than=2048 -fno-stack-protector -Wno-unused-but-set-variable -Wno-unused-const-variable -fno-omit-frame-pointer -fno-optimize-sibling-calls -fno-var-tracking-assignments -g -Wdeclaration-after-statement -Wno-pointer-sign -fno-strict-overflow -fno-merge-all-constants -fmerge-constants -fno-stack-check -fconserve-stack -Werror=implicit-int -Werror=strict-prototypes -Werror=date-time -Werror=incompatible-pointer-types -Werror=designated-init  -DMODULE -mcmodel=large  -DKBUILD_BASENAME='"rt2x00config"'  -DKBUILD_MODNAME='"rt2x00lib"' -c -o drivers/net/wireless/ralink/rt2x00/.tmp_rt2x00config.o /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/drivers/net/wireless/ralink/rt2x00/rt2x00config.c

source_drivers/net/wireless/ralink/rt2x00/rt2x00config.o := /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/drivers/net/wireless/ralink/rt2x00/rt2x00config.c

deps_drivers/net/wireless/ralink/rt2x00/rt2x00config.o := \
    $(wildcard include/config/update/type.h) \
    $(wildcard include/config/update/mac.h) \
    $(wildcard include/config/update/bssid.h) \
    $(wildcard include/config/ht/disabled.h) \
    $(wildcard include/config/channel/ht40.h) \
    $(wildcard include/config/powersaving.h) \
    $(wildcard include/config/monitoring.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/compiler_types.h \
    $(wildcard include/config/enable/must/check.h) \
    $(wildcard include/config/enable/warn/deprecated.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/compiler-gcc.h \
    $(wildcard include/config/arch/supports/optimized/inlining.h) \
    $(wildcard include/config/optimize/inlining.h) \
    $(wildcard include/config/gcov/kernel.h) \
    $(wildcard include/config/arch/use/builtin/bswap.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/kernel.h \
    $(wildcard include/config/lbdaf.h) \
    $(wildcard include/config/preempt/voluntary.h) \
    $(wildcard include/config/debug/atomic/sleep.h) \
    $(wildcard include/config/mmu.h) \
    $(wildcard include/config/prove/locking.h) \
    $(wildcard include/config/arch/has/refcount.h) \
    $(wildcard include/config/panic/timeout.h) \
    $(wildcard include/config/tracing.h) \
    $(wildcard include/config/ftrace/mcount/record.h) \
  /usr/lib/gcc-cross/aarch64-linux-gnu/7/include/stdarg.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/linkage.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/stringify.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/export.h \
    $(wildcard include/config/have/underscore/symbol/prefix.h) \
    $(wildcard include/config/modules.h) \
    $(wildcard include/config/modversions.h) \
    $(wildcard include/config/module/rel/crcs.h) \
    $(wildcard include/config/trim/unused/ksyms.h) \
    $(wildcard include/config/unused/symbols.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/linkage.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/stddef.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/stddef.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/types.h \
    $(wildcard include/config/have/uid16.h) \
    $(wildcard include/config/uid16.h) \
    $(wildcard include/config/arch/dma/addr/t/64bit.h) \
    $(wildcard include/config/phys/addr/t/64bit.h) \
    $(wildcard include/config/64bit.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/types.h \
  arch/arm64/include/generated/uapi/asm/types.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/asm-generic/types.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/asm-generic/int-ll64.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/asm-generic/int-ll64.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/uapi/asm/bitsperlong.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/asm-generic/bitsperlong.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/asm-generic/bitsperlong.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/posix_types.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/uapi/asm/posix_types.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/asm-generic/posix_types.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/compiler.h \
    $(wildcard include/config/trace/branch/profiling.h) \
    $(wildcard include/config/profile/all/branches.h) \
    $(wildcard include/config/stack/validation.h) \
    $(wildcard include/config/kasan.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/barrier.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/asm-generic/barrier.h \
    $(wildcard include/config/smp.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/bitops.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/bitops.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/asm-generic/bitops/builtin-__ffs.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/asm-generic/bitops/builtin-ffs.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/asm-generic/bitops/builtin-__fls.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/asm-generic/bitops/builtin-fls.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/asm-generic/bitops/ffz.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/asm-generic/bitops/fls64.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/asm-generic/bitops/find.h \
    $(wildcard include/config/generic/find/first/bit.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/asm-generic/bitops/sched.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/asm-generic/bitops/hweight.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/asm-generic/bitops/arch_hweight.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/asm-generic/bitops/const_hweight.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/asm-generic/bitops/lock.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/asm-generic/bitops/non-atomic.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/asm-generic/bitops/le.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/uapi/asm/byteorder.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/byteorder/little_endian.h \
    $(wildcard include/config/cpu/big/endian.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/byteorder/little_endian.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/swab.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/swab.h \
  arch/arm64/include/generated/uapi/asm/swab.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/asm-generic/swab.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/byteorder/generic.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/log2.h \
    $(wildcard include/config/arch/has/ilog2/u32.h) \
    $(wildcard include/config/arch/has/ilog2/u64.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/typecheck.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/printk.h \
    $(wildcard include/config/message/loglevel/default.h) \
    $(wildcard include/config/console/loglevel/default.h) \
    $(wildcard include/config/early/printk.h) \
    $(wildcard include/config/printk/nmi.h) \
    $(wildcard include/config/printk.h) \
    $(wildcard include/config/dynamic/debug.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/init.h \
    $(wildcard include/config/strict/kernel/rwx.h) \
    $(wildcard include/config/strict/module/rwx.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/kern_levels.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/cache.h \
    $(wildcard include/config/arch/has/cache/line/size.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/kernel.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/sysinfo.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/cache.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/cputype.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/sysreg.h \
    $(wildcard include/config/broken/gas/inst.h) \
    $(wildcard include/config/arm64/4k/pages.h) \
    $(wildcard include/config/arm64/16k/pages.h) \
    $(wildcard include/config/arm64/64k/pages.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/build_bug.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/module.h \
    $(wildcard include/config/sysfs.h) \
    $(wildcard include/config/modules/tree/lookup.h) \
    $(wildcard include/config/livepatch.h) \
    $(wildcard include/config/module/sig.h) \
    $(wildcard include/config/generic/bug.h) \
    $(wildcard include/config/kallsyms.h) \
    $(wildcard include/config/tracepoints.h) \
    $(wildcard include/config/event/tracing.h) \
    $(wildcard include/config/module/unload.h) \
    $(wildcard include/config/constructors.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/list.h \
    $(wildcard include/config/debug/list.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/poison.h \
    $(wildcard include/config/illegal/pointer/value.h) \
    $(wildcard include/config/page/poisoning/zero.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/const.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/stat.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/stat.h \
    $(wildcard include/config/compat.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/uapi/asm/stat.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/asm-generic/stat.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/compat.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/sched.h \
    $(wildcard include/config/virt/cpu/accounting/native.h) \
    $(wildcard include/config/sched/info.h) \
    $(wildcard include/config/schedstats.h) \
    $(wildcard include/config/fair/group/sched.h) \
    $(wildcard include/config/rt/group/sched.h) \
    $(wildcard include/config/thread/info/in/task.h) \
    $(wildcard include/config/cgroup/sched.h) \
    $(wildcard include/config/preempt/notifiers.h) \
    $(wildcard include/config/blk/dev/io/trace.h) \
    $(wildcard include/config/preempt/rcu.h) \
    $(wildcard include/config/tasks/rcu.h) \
    $(wildcard include/config/memcg.h) \
    $(wildcard include/config/slob.h) \
    $(wildcard include/config/compat/brk.h) \
    $(wildcard include/config/cgroups.h) \
    $(wildcard include/config/cc/stackprotector.h) \
    $(wildcard include/config/arch/has/scaled/cputime.h) \
    $(wildcard include/config/virt/cpu/accounting/gen.h) \
    $(wildcard include/config/no/hz/full.h) \
    $(wildcard include/config/posix/timers.h) \
    $(wildcard include/config/sysvipc.h) \
    $(wildcard include/config/detect/hung/task.h) \
    $(wildcard include/config/auditsyscall.h) \
    $(wildcard include/config/rt/mutexes.h) \
    $(wildcard include/config/debug/mutexes.h) \
    $(wildcard include/config/trace/irqflags.h) \
    $(wildcard include/config/lockdep.h) \
    $(wildcard include/config/lockdep/crossrelease.h) \
    $(wildcard include/config/ubsan.h) \
    $(wildcard include/config/block.h) \
    $(wildcard include/config/task/xacct.h) \
    $(wildcard include/config/cpusets.h) \
    $(wildcard include/config/intel/rdt.h) \
    $(wildcard include/config/futex.h) \
    $(wildcard include/config/perf/events.h) \
    $(wildcard include/config/debug/preempt.h) \
    $(wildcard include/config/numa.h) \
    $(wildcard include/config/numa/balancing.h) \
    $(wildcard include/config/task/delay/acct.h) \
    $(wildcard include/config/fault/injection.h) \
    $(wildcard include/config/latencytop.h) \
    $(wildcard include/config/function/graph/tracer.h) \
    $(wildcard include/config/kcov.h) \
    $(wildcard include/config/uprobes.h) \
    $(wildcard include/config/bcache.h) \
    $(wildcard include/config/vmap/stack.h) \
    $(wildcard include/config/security.h) \
    $(wildcard include/config/preempt.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/sched.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/current.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/pid.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/rculist.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/rcupdate.h \
    $(wildcard include/config/preempt/count.h) \
    $(wildcard include/config/rcu/stall/common.h) \
    $(wildcard include/config/rcu/nocb/cpu.h) \
    $(wildcard include/config/tree/rcu.h) \
    $(wildcard include/config/tiny/rcu.h) \
    $(wildcard include/config/debug/objects/rcu/head.h) \
    $(wildcard include/config/hotplug/cpu.h) \
    $(wildcard include/config/prove/rcu.h) \
    $(wildcard include/config/debug/lock/alloc.h) \
    $(wildcard include/config/rcu/boost.h) \
    $(wildcard include/config/arch/weak/release/acquire.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/atomic.h \
    $(wildcard include/config/generic/atomic64.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/atomic.h \
    $(wildcard include/config/arm64/lse/atomics.h) \
    $(wildcard include/config/as/lse.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/lse.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/atomic_ll_sc.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/cmpxchg.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/bug.h \
    $(wildcard include/config/bug/on/data/corruption.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/bug.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/asm-bug.h \
    $(wildcard include/config/debug/bugverbose.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/brk-imm.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/asm-generic/bug.h \
    $(wildcard include/config/bug.h) \
    $(wildcard include/config/generic/bug/relative/pointers.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/asm-generic/atomic-long.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/irqflags.h \
    $(wildcard include/config/irqsoff/tracer.h) \
    $(wildcard include/config/preempt/tracer.h) \
    $(wildcard include/config/trace/irqflags/support.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/irqflags.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/ptrace.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/uapi/asm/ptrace.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/hwcap.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/uapi/asm/hwcap.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/asm-generic/ptrace.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/preempt.h \
  arch/arm64/include/generated/asm/preempt.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/asm-generic/preempt.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/thread_info.h \
    $(wildcard include/config/debug/stack/usage.h) \
    $(wildcard include/config/debug/kmemleak.h) \
    $(wildcard include/config/have/arch/within/stack/frames.h) \
    $(wildcard include/config/hardened/usercopy.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/restart_block.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/thread_info.h \
    $(wildcard include/config/arm64/sw/ttbr0/pan.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/memory.h \
    $(wildcard include/config/arm64/va/bits.h) \
    $(wildcard include/config/debug/align/rodata.h) \
    $(wildcard include/config/blk/dev/initrd.h) \
    $(wildcard include/config/debug/virtual.h) \
    $(wildcard include/config/sparsemem/vmemmap.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/page-def.h \
    $(wildcard include/config/arm64/page/shift.h) \
    $(wildcard include/config/arm64/cont/shift.h) \
  arch/arm64/include/generated/asm/sizes.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/asm-generic/sizes.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/sizes.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/mmdebug.h \
    $(wildcard include/config/debug/vm.h) \
    $(wildcard include/config/debug/vm/pgflags.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/asm-generic/memory_model.h \
    $(wildcard include/config/flatmem.h) \
    $(wildcard include/config/discontigmem.h) \
    $(wildcard include/config/sparsemem.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/pfn.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/stack_pointer.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/bottom_half.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/lockdep.h \
    $(wildcard include/config/lock/stat.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/processor.h \
    $(wildcard include/config/have/hw/breakpoint.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/string.h \
    $(wildcard include/config/binary/printf.h) \
    $(wildcard include/config/fortify/source.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/string.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/string.h \
    $(wildcard include/config/arch/has/uaccess/flushcache.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/alternative.h \
    $(wildcard include/config/arm64/uao.h) \
    $(wildcard include/config/foo.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/cpucaps.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/insn.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/fpsimd.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/hw_breakpoint.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/cpufeature.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/jump_label.h \
    $(wildcard include/config/jump/label.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/jump_label.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/virt.h \
    $(wildcard include/config/arm64/vhe.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/sections.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/asm-generic/sections.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/pgtable-hwdef.h \
    $(wildcard include/config/pgtable/levels.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/cpumask.h \
    $(wildcard include/config/cpumask/offstack.h) \
    $(wildcard include/config/debug/per/cpu/maps.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/threads.h \
    $(wildcard include/config/nr/cpus.h) \
    $(wildcard include/config/base/small.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/bitmap.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/rcutree.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/sem.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/time64.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/time.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/math64.h \
    $(wildcard include/config/arch/supports/int128.h) \
  arch/arm64/include/generated/asm/div64.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/asm-generic/div64.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/sem.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/ipc.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/spinlock.h \
    $(wildcard include/config/debug/spinlock.h) \
    $(wildcard include/config/generic/lockbreak.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/spinlock_types.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/spinlock_types.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/rwlock_types.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/spinlock.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/rwlock.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/spinlock_api_smp.h \
    $(wildcard include/config/inline/spin/lock.h) \
    $(wildcard include/config/inline/spin/lock/bh.h) \
    $(wildcard include/config/inline/spin/lock/irq.h) \
    $(wildcard include/config/inline/spin/lock/irqsave.h) \
    $(wildcard include/config/inline/spin/trylock.h) \
    $(wildcard include/config/inline/spin/trylock/bh.h) \
    $(wildcard include/config/uninline/spin/unlock.h) \
    $(wildcard include/config/inline/spin/unlock/bh.h) \
    $(wildcard include/config/inline/spin/unlock/irq.h) \
    $(wildcard include/config/inline/spin/unlock/irqrestore.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/rwlock_api_smp.h \
    $(wildcard include/config/inline/read/lock.h) \
    $(wildcard include/config/inline/write/lock.h) \
    $(wildcard include/config/inline/read/lock/bh.h) \
    $(wildcard include/config/inline/write/lock/bh.h) \
    $(wildcard include/config/inline/read/lock/irq.h) \
    $(wildcard include/config/inline/write/lock/irq.h) \
    $(wildcard include/config/inline/read/lock/irqsave.h) \
    $(wildcard include/config/inline/write/lock/irqsave.h) \
    $(wildcard include/config/inline/read/trylock.h) \
    $(wildcard include/config/inline/write/trylock.h) \
    $(wildcard include/config/inline/read/unlock.h) \
    $(wildcard include/config/inline/write/unlock.h) \
    $(wildcard include/config/inline/read/unlock/bh.h) \
    $(wildcard include/config/inline/write/unlock/bh.h) \
    $(wildcard include/config/inline/read/unlock/irq.h) \
    $(wildcard include/config/inline/write/unlock/irq.h) \
    $(wildcard include/config/inline/read/unlock/irqrestore.h) \
    $(wildcard include/config/inline/write/unlock/irqrestore.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/uidgid.h \
    $(wildcard include/config/multiuser.h) \
    $(wildcard include/config/user/ns.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/highuid.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/rhashtable.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/err.h \
  arch/arm64/include/generated/uapi/asm/errno.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/asm-generic/errno.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/asm-generic/errno-base.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/errno.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/errno.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/jhash.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/unaligned/packed_struct.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/list_nulls.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/workqueue.h \
    $(wildcard include/config/debug/objects/work.h) \
    $(wildcard include/config/freezer.h) \
    $(wildcard include/config/wq/watchdog.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/timer.h \
    $(wildcard include/config/debug/objects/timers.h) \
    $(wildcard include/config/no/hz/common.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/ktime.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/time.h \
    $(wildcard include/config/arch/uses/gettimeoffset.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/seqlock.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/jiffies.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/timex.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/timex.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/param.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/uapi/asm/param.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/asm-generic/param.h \
    $(wildcard include/config/hz.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/asm-generic/param.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/timex.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/arch_timer.h \
    $(wildcard include/config/arm/arch/timer/ool/workaround.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/smp.h \
    $(wildcard include/config/up/late/init.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/llist.h \
    $(wildcard include/config/arch/have/nmi/safe/cmpxchg.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/smp.h \
    $(wildcard include/config/arm64/acpi/parking/protocol.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/percpu.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/asm-generic/percpu.h \
    $(wildcard include/config/have/setup/per/cpu/area.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/percpu-defs.h \
    $(wildcard include/config/debug/force/weak/per/cpu.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/clocksource/arm_arch_timer.h \
    $(wildcard include/config/arm/arch/timer.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/timecounter.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/asm-generic/timex.h \
  include/generated/timeconst.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/timekeeping.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/debugobjects.h \
    $(wildcard include/config/debug/objects.h) \
    $(wildcard include/config/debug/objects/free.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/mutex.h \
    $(wildcard include/config/mutex/spin/on/owner.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/osq_lock.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/debug_locks.h \
    $(wildcard include/config/debug/locking/api/selftests.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/ipc.h \
  arch/arm64/include/generated/uapi/asm/ipcbuf.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/asm-generic/ipcbuf.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/refcount.h \
    $(wildcard include/config/refcount/full.h) \
  arch/arm64/include/generated/uapi/asm/sembuf.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/asm-generic/sembuf.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/shm.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/page.h \
    $(wildcard include/config/have/arch/pfn/valid.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/personality.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/personality.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/pgtable-types.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/asm-generic/5level-fixup.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/asm-generic/getorder.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/shm.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/asm-generic/hugetlb_encode.h \
  arch/arm64/include/generated/uapi/asm/shmbuf.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/asm-generic/shmbuf.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/shmparam.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/asm-generic/shmparam.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/kcov.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/kcov.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/plist.h \
    $(wildcard include/config/debug/pi/list.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/hrtimer.h \
    $(wildcard include/config/high/res/timers.h) \
    $(wildcard include/config/time/low/res.h) \
    $(wildcard include/config/timerfd.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/rbtree.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/percpu.h \
    $(wildcard include/config/need/per/cpu/embed/first/chunk.h) \
    $(wildcard include/config/need/per/cpu/page/first/chunk.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/timerqueue.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/seccomp.h \
    $(wildcard include/config/seccomp.h) \
    $(wildcard include/config/have/arch/seccomp/filter.h) \
    $(wildcard include/config/seccomp/filter.h) \
    $(wildcard include/config/checkpoint/restore.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/seccomp.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/seccomp.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/unistd.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/uapi/asm/unistd.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/asm-generic/unistd.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/asm-generic/unistd.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/asm-generic/seccomp.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/unistd.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/nodemask.h \
    $(wildcard include/config/highmem.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/numa.h \
    $(wildcard include/config/nodes/shift.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/resource.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/resource.h \
  arch/arm64/include/generated/uapi/asm/resource.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/asm-generic/resource.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/asm-generic/resource.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/latencytop.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/sched/prio.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/signal_types.h \
    $(wildcard include/config/old/sigaction.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/signal.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/uapi/asm/signal.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/asm-generic/signal.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/asm-generic/signal.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/asm-generic/signal-defs.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/uapi/asm/sigcontext.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/uapi/asm/siginfo.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/asm-generic/siginfo.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/mm_types_task.h \
    $(wildcard include/config/arch/want/batched/unmap/tlb/flush.h) \
    $(wildcard include/config/split/ptlock/cpus.h) \
    $(wildcard include/config/arch/enable/split/pmd/ptlock.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/task_io_accounting.h \
    $(wildcard include/config/task/io/accounting.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/sched/task_stack.h \
    $(wildcard include/config/stack/growsup.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/magic.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/stat.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/kmod.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/umh.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/gfp.h \
    $(wildcard include/config/zone/dma.h) \
    $(wildcard include/config/zone/dma32.h) \
    $(wildcard include/config/zone/device.h) \
    $(wildcard include/config/pm/sleep.h) \
    $(wildcard include/config/memory/isolation.h) \
    $(wildcard include/config/compaction.h) \
    $(wildcard include/config/cma.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/mmzone.h \
    $(wildcard include/config/force/max/zoneorder.h) \
    $(wildcard include/config/zsmalloc.h) \
    $(wildcard include/config/memory/hotplug.h) \
    $(wildcard include/config/flat/node/mem/map.h) \
    $(wildcard include/config/page/extension.h) \
    $(wildcard include/config/no/bootmem.h) \
    $(wildcard include/config/deferred/struct/page/init.h) \
    $(wildcard include/config/transparent/hugepage.h) \
    $(wildcard include/config/have/memory/present.h) \
    $(wildcard include/config/have/memoryless/nodes.h) \
    $(wildcard include/config/need/node/memmap/size.h) \
    $(wildcard include/config/have/memblock/node/map.h) \
    $(wildcard include/config/need/multiple/nodes.h) \
    $(wildcard include/config/have/arch/early/pfn/to/nid.h) \
    $(wildcard include/config/sparsemem/extreme.h) \
    $(wildcard include/config/memory/hotremove.h) \
    $(wildcard include/config/holes/in/zone.h) \
    $(wildcard include/config/arch/has/holes/memorymodel.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/wait.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/wait.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/pageblock-flags.h \
    $(wildcard include/config/hugetlb/page.h) \
    $(wildcard include/config/hugetlb/page/size/variable.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/page-flags-layout.h \
  include/generated/bounds.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/sparsemem.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/memory_hotplug.h \
    $(wildcard include/config/arch/has/add/pages.h) \
    $(wildcard include/config/have/arch/nodedata/extension.h) \
    $(wildcard include/config/have/bootmem/info/node.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/notifier.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/rwsem.h \
    $(wildcard include/config/rwsem/spin/on/owner.h) \
    $(wildcard include/config/rwsem/generic/spinlock.h) \
  arch/arm64/include/generated/asm/rwsem.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/asm-generic/rwsem.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/srcu.h \
    $(wildcard include/config/tiny/srcu.h) \
    $(wildcard include/config/tree/srcu.h) \
    $(wildcard include/config/srcu.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/rcu_segcblist.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/srcutree.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/rcu_node_tree.h \
    $(wildcard include/config/rcu/fanout.h) \
    $(wildcard include/config/rcu/fanout/leaf.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/completion.h \
    $(wildcard include/config/lockdep/completions.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/mmzone.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/numa.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/topology.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/asm-generic/topology.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/topology.h \
    $(wildcard include/config/use/percpu/numa/node/id.h) \
    $(wildcard include/config/sched/smt.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/sysctl.h \
    $(wildcard include/config/sysctl.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/sysctl.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/elf.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/elf.h \
  arch/arm64/include/generated/asm/user.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/asm-generic/user.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/elf.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/elf-em.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/kobject.h \
    $(wildcard include/config/uevent/helper.h) \
    $(wildcard include/config/debug/kobject/release.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/sysfs.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/kernfs.h \
    $(wildcard include/config/kernfs.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/idr.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/radix-tree.h \
    $(wildcard include/config/radix/tree/multiorder.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/kobject_ns.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/kref.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/moduleparam.h \
    $(wildcard include/config/alpha.h) \
    $(wildcard include/config/ia64.h) \
    $(wildcard include/config/ppc64.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/rbtree_latch.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/module.h \
    $(wildcard include/config/arm64/module/plts.h) \
    $(wildcard include/config/dynamic/ftrace.h) \
    $(wildcard include/config/randomize/base.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/asm-generic/module.h \
    $(wildcard include/config/have/mod/arch/specific.h) \
    $(wildcard include/config/modules/use/elf/rel.h) \
    $(wildcard include/config/modules/use/elf/rela.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/drivers/net/wireless/ralink/rt2x00/rt2x00.h \
    $(wildcard include/config/rt2x00/debug.h) \
    $(wildcard include/config/rt2x00/lib/debugfs.h) \
    $(wildcard include/config/qos/disabled.h) \
    $(wildcard include/config/rt2x00/lib/leds.h) \
    $(wildcard include/config/rt2x00/lib/crypto.h) \
    $(wildcard include/config/pm.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/interrupt.h \
    $(wildcard include/config/irq/forced/threading.h) \
    $(wildcard include/config/generic/irq/probe.h) \
    $(wildcard include/config/proc/fs.h) \
    $(wildcard include/config/irq/timings.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/irqreturn.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/irqnr.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/irqnr.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/hardirq.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/ftrace_irq.h \
    $(wildcard include/config/ftrace/nmi/enter.h) \
    $(wildcard include/config/hwlat/tracer.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/vtime.h \
    $(wildcard include/config/virt/cpu/accounting.h) \
    $(wildcard include/config/irq/time/accounting.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/context_tracking_state.h \
    $(wildcard include/config/context/tracking.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/static_key.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/hardirq.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/irq.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/asm-generic/irq.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/irq_cpustat.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/skbuff.h \
    $(wildcard include/config/nf/conntrack.h) \
    $(wildcard include/config/bridge/netfilter.h) \
    $(wildcard include/config/xfrm.h) \
    $(wildcard include/config/ipv6/ndisc/nodetype.h) \
    $(wildcard include/config/net/switchdev.h) \
    $(wildcard include/config/net/cls/act.h) \
    $(wildcard include/config/net/sched.h) \
    $(wildcard include/config/net/rx/busy/poll.h) \
    $(wildcard include/config/xps.h) \
    $(wildcard include/config/network/secmark.h) \
    $(wildcard include/config/network/phy/timestamping.h) \
    $(wildcard include/config/netfilter/xt/target/trace.h) \
    $(wildcard include/config/nf/tables.h) \
    $(wildcard include/config/ip/vs.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/socket.h \
  arch/arm64/include/generated/uapi/asm/socket.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/asm-generic/socket.h \
  arch/arm64/include/generated/uapi/asm/sockios.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/asm-generic/sockios.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/sockios.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/uio.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/uio.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/socket.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/net.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/random.h \
    $(wildcard include/config/gcc/plugin/latent/entropy.h) \
    $(wildcard include/config/arch/random.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/once.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/random.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/ioctl.h \
  arch/arm64/include/generated/uapi/asm/ioctl.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/asm-generic/ioctl.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/asm-generic/ioctl.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/fcntl.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/fcntl.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/uapi/asm/fcntl.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/asm-generic/fcntl.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/fs.h \
    $(wildcard include/config/fs/posix/acl.h) \
    $(wildcard include/config/cgroup/writeback.h) \
    $(wildcard include/config/ima.h) \
    $(wildcard include/config/fsnotify.h) \
    $(wildcard include/config/fs/encryption.h) \
    $(wildcard include/config/epoll.h) \
    $(wildcard include/config/file/locking.h) \
    $(wildcard include/config/quota.h) \
    $(wildcard include/config/fs/dax.h) \
    $(wildcard include/config/mandatory/file/locking.h) \
    $(wildcard include/config/migration.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/wait_bit.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/kdev_t.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/kdev_t.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/dcache.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/rculist_bl.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/list_bl.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/bit_spinlock.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/lockref.h \
    $(wildcard include/config/arch/use/cmpxchg/lockref.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/stringhash.h \
    $(wildcard include/config/dcache/word/access.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/hash.h \
    $(wildcard include/config/have/arch/hash.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/path.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/list_lru.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/shrinker.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/mm_types.h \
    $(wildcard include/config/have/cmpxchg/double.h) \
    $(wildcard include/config/have/aligned/struct/page.h) \
    $(wildcard include/config/userfaultfd.h) \
    $(wildcard include/config/have/arch/compat/mmap/bases.h) \
    $(wildcard include/config/membarrier.h) \
    $(wildcard include/config/aio.h) \
    $(wildcard include/config/mmu/notifier.h) \
    $(wildcard include/config/hmm.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/auxvec.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/auxvec.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/uapi/asm/auxvec.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/uprobes.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/mmu.h \
    $(wildcard include/config/unmap/kernel/at/el0.h) \
    $(wildcard include/config/harden/branch/predictor.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/capability.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/capability.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/semaphore.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/fiemap.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/migrate_mode.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/percpu-rwsem.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/rcuwait.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/rcu_sync.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/delayed_call.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/uuid.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/uuid.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/errseq.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/fs.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/limits.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/quota.h \
    $(wildcard include/config/quota/netlink/interface.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/percpu_counter.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/dqblk_xfs.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/dqblk_v1.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/dqblk_v2.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/dqblk_qtree.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/projid.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/quota.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/nfs_fs_i.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/net.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/textsearch.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/slab.h \
    $(wildcard include/config/debug/slab.h) \
    $(wildcard include/config/failslab.h) \
    $(wildcard include/config/have/hardened/usercopy/allocator.h) \
    $(wildcard include/config/slab.h) \
    $(wildcard include/config/slub.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/kmemleak.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/vmalloc.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/kasan.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/net/checksum.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/uaccess.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/kasan-checks.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/uaccess.h \
    $(wildcard include/config/arm64/pan.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/kernel-pgtable.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/pgtable.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/proc-fns.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/pgtable-prot.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/fixmap.h \
    $(wildcard include/config/acpi/apei/ghes.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/boot.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/asm-generic/fixmap.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/asm-generic/pgtable.h \
    $(wildcard include/config/have/arch/transparent/hugepage/pud.h) \
    $(wildcard include/config/have/arch/soft/dirty.h) \
    $(wildcard include/config/arch/enable/thp/migration.h) \
    $(wildcard include/config/have/arch/huge/vmap.h) \
    $(wildcard include/config/x86/espfix64.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/compiler.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/extable.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/checksum.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/asm-generic/checksum.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/dma-mapping.h \
    $(wildcard include/config/have/generic/dma/coherent.h) \
    $(wildcard include/config/has/dma.h) \
    $(wildcard include/config/arch/has/dma/set/coherent/mask.h) \
    $(wildcard include/config/need/dma/map/state.h) \
    $(wildcard include/config/dma/api/debug.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/device.h \
    $(wildcard include/config/debug/devres.h) \
    $(wildcard include/config/generic/msi/irq/domain.h) \
    $(wildcard include/config/pinctrl.h) \
    $(wildcard include/config/generic/msi/irq.h) \
    $(wildcard include/config/dma/cma.h) \
    $(wildcard include/config/of.h) \
    $(wildcard include/config/devtmpfs.h) \
    $(wildcard include/config/sysfs/deprecated.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/ioport.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/klist.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/pinctrl/devinfo.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/pinctrl/consumer.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/seq_file.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/cred.h \
    $(wildcard include/config/debug/credentials.h) \
    $(wildcard include/config/keys.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/key.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/assoc_array.h \
    $(wildcard include/config/associative/array.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/selinux.h \
    $(wildcard include/config/security/selinux.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/sched/user.h \
    $(wildcard include/config/fanotify.h) \
    $(wildcard include/config/posix/mqueue.h) \
    $(wildcard include/config/bpf/syscall.h) \
    $(wildcard include/config/net.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/pinctrl/pinctrl-state.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/pm.h \
    $(wildcard include/config/vt/console/sleep.h) \
    $(wildcard include/config/pm/clk.h) \
    $(wildcard include/config/pm/generic/domains.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/ratelimit.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/device.h \
    $(wildcard include/config/iommu/api.h) \
    $(wildcard include/config/xen.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/pm_wakeup.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/dma-debug.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/dma-direction.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/scatterlist.h \
    $(wildcard include/config/debug/sg.h) \
    $(wildcard include/config/need/sg/dma/length.h) \
    $(wildcard include/config/arch/has/sg/chain.h) \
    $(wildcard include/config/sg/pool.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/mm.h \
    $(wildcard include/config/have/arch/mmap/rnd/bits.h) \
    $(wildcard include/config/have/arch/mmap/rnd/compat/bits.h) \
    $(wildcard include/config/mem/soft/dirty.h) \
    $(wildcard include/config/arch/uses/high/vma/flags.h) \
    $(wildcard include/config/x86.h) \
    $(wildcard include/config/x86/intel/memory/protection/keys.h) \
    $(wildcard include/config/ppc.h) \
    $(wildcard include/config/parisc.h) \
    $(wildcard include/config/metag.h) \
    $(wildcard include/config/x86/intel/mpx.h) \
    $(wildcard include/config/device/private.h) \
    $(wildcard include/config/device/public.h) \
    $(wildcard include/config/shmem.h) \
    $(wildcard include/config/debug/vm/rb.h) \
    $(wildcard include/config/page/poisoning.h) \
    $(wildcard include/config/debug/pagealloc.h) \
    $(wildcard include/config/hibernation.h) \
    $(wildcard include/config/hugetlbfs.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/range.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/percpu-refcount.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/page_ext.h \
    $(wildcard include/config/idle/page/tracking.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/stacktrace.h \
    $(wildcard include/config/stacktrace.h) \
    $(wildcard include/config/user/stacktrace/support.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/stackdepot.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/page_ref.h \
    $(wildcard include/config/debug/page/ref.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/page-flags.h \
    $(wildcard include/config/arch/uses/pg/uncached.h) \
    $(wildcard include/config/memory/failure.h) \
    $(wildcard include/config/swap.h) \
    $(wildcard include/config/thp/swap.h) \
    $(wildcard include/config/ksm.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/tracepoint-defs.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/memremap.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/huge_mm.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/sched/coredump.h \
    $(wildcard include/config/core/dump/default/elf/headers.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/vmstat.h \
    $(wildcard include/config/vm/event/counters.h) \
    $(wildcard include/config/debug/tlbflush.h) \
    $(wildcard include/config/debug/vm/vmacache.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/vm_event_item.h \
    $(wildcard include/config/memory/balloon.h) \
    $(wildcard include/config/balloon/compaction.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/io.h \
  arch/arm64/include/generated/asm/early_ioremap.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/asm-generic/early_ioremap.h \
    $(wildcard include/config/generic/early/ioremap.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/xen/xen.h \
    $(wildcard include/config/xen/pvh.h) \
    $(wildcard include/config/xen/dom0.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/xen/interface/xen.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/xen/interface.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/xen/arm/interface.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/xen/hypervisor.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/xen/arm/hypervisor.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/asm-generic/io.h \
    $(wildcard include/config/generic/iomap.h) \
    $(wildcard include/config/has/ioport/map.h) \
    $(wildcard include/config/virt/to/bus.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/asm-generic/pci_iomap.h \
    $(wildcard include/config/pci.h) \
    $(wildcard include/config/no/generic/pci/ioport/map.h) \
    $(wildcard include/config/generic/pci/iomap.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/mem_encrypt.h \
    $(wildcard include/config/arch/has/mem/encrypt.h) \
    $(wildcard include/config/amd/mem/encrypt.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/dma-mapping.h \
    $(wildcard include/config/iommu/dma.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/netdev_features.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/sched/clock.h \
    $(wildcard include/config/have/unstable/sched/clock.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/net/flow_dissector.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/in6.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/in6.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/libc-compat.h \
    $(wildcard include/config/data.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/if_ether.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/splice.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/pipe_fs_i.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/if_packet.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/net/flow.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/firmware.h \
    $(wildcard include/config/fw/loader.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/leds.h \
    $(wildcard include/config/leds/triggers.h) \
    $(wildcard include/config/leds/brightness/hw/changed.h) \
    $(wildcard include/config/leds/trigger/disk.h) \
    $(wildcard include/config/leds/trigger/mtd.h) \
    $(wildcard include/config/leds/trigger/camera.h) \
    $(wildcard include/config/new/leds.h) \
    $(wildcard include/config/leds/trigger/cpu.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/etherdevice.h \
    $(wildcard include/config/have/efficient/unaligned/access.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/if_ether.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/netdevice.h \
    $(wildcard include/config/dcb.h) \
    $(wildcard include/config/hyperv/net.h) \
    $(wildcard include/config/wlan.h) \
    $(wildcard include/config/ax25.h) \
    $(wildcard include/config/mac80211/mesh.h) \
    $(wildcard include/config/net/ipip.h) \
    $(wildcard include/config/net/ipgre.h) \
    $(wildcard include/config/ipv6/sit.h) \
    $(wildcard include/config/ipv6/tunnel.h) \
    $(wildcard include/config/rps.h) \
    $(wildcard include/config/netpoll.h) \
    $(wildcard include/config/bql.h) \
    $(wildcard include/config/rfs/accel.h) \
    $(wildcard include/config/fcoe.h) \
    $(wildcard include/config/xfrm/offload.h) \
    $(wildcard include/config/net/poll/controller.h) \
    $(wildcard include/config/libfcoe.h) \
    $(wildcard include/config/wireless/ext.h) \
    $(wildcard include/config/net/l3/master/dev.h) \
    $(wildcard include/config/ipv6.h) \
    $(wildcard include/config/vlan/8021q.h) \
    $(wildcard include/config/net/dsa.h) \
    $(wildcard include/config/tipc.h) \
    $(wildcard include/config/mpls/routing.h) \
    $(wildcard include/config/netfilter/ingress.h) \
    $(wildcard include/config/garp.h) \
    $(wildcard include/config/mrp.h) \
    $(wildcard include/config/cgroup/net/prio.h) \
    $(wildcard include/config/net/flow/limit.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/delay.h \
  arch/arm64/include/generated/asm/delay.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/asm-generic/delay.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/prefetch.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/dynamic_queue_limits.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/ethtool.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/compat.h \
    $(wildcard include/config/compat/old/sigaction.h) \
    $(wildcard include/config/odd/rt/sigaction.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/if.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/hdlc/ioctl.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/aio_abi.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/ethtool.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/net/net_namespace.h \
    $(wildcard include/config/ieee802154/6lowpan.h) \
    $(wildcard include/config/ip/sctp.h) \
    $(wildcard include/config/ip/dccp.h) \
    $(wildcard include/config/netfilter.h) \
    $(wildcard include/config/nf/defrag/ipv6.h) \
    $(wildcard include/config/netfilter/netlink/acct.h) \
    $(wildcard include/config/nf/ct/netlink/timeout.h) \
    $(wildcard include/config/wext/core.h) \
    $(wildcard include/config/mpls.h) \
    $(wildcard include/config/can.h) \
    $(wildcard include/config/net/ns.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/net/netns/core.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/net/netns/mib.h \
    $(wildcard include/config/xfrm/statistics.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/net/snmp.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/snmp.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/u64_stats_sync.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/net/netns/unix.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/net/netns/packet.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/net/netns/ipv4.h \
    $(wildcard include/config/ip/multiple/tables.h) \
    $(wildcard include/config/ip/route/classid.h) \
    $(wildcard include/config/ip/mroute.h) \
    $(wildcard include/config/ip/mroute/multiple/tables.h) \
    $(wildcard include/config/ip/route/multipath.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/net/inet_frag.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/net/netns/ipv6.h \
    $(wildcard include/config/ipv6/multiple/tables.h) \
    $(wildcard include/config/ipv6/mroute.h) \
    $(wildcard include/config/ipv6/mroute/multiple/tables.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/net/dst_ops.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/net/netns/ieee802154_6lowpan.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/net/netns/sctp.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/net/netns/dccp.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/net/netns/netfilter.h \
    $(wildcard include/config/nf/defrag/ipv4.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/netfilter_defs.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/netfilter.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/in.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/in.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/net/netns/x_tables.h \
    $(wildcard include/config/bridge/nf/ebtables.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/net/netns/conntrack.h \
    $(wildcard include/config/nf/ct/proto/dccp.h) \
    $(wildcard include/config/nf/ct/proto/sctp.h) \
    $(wildcard include/config/nf/conntrack/events.h) \
    $(wildcard include/config/nf/conntrack/labels.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/netfilter/nf_conntrack_tcp.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/netfilter/nf_conntrack_tcp.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/netfilter/nf_conntrack_dccp.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/netfilter/nf_conntrack_tuple_common.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/netfilter/nf_conntrack_common.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/netfilter/nf_conntrack_common.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/netfilter/nf_conntrack_sctp.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/netfilter/nf_conntrack_sctp.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/net/netns/nftables.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/net/netns/xfrm.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/xfrm.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/net/netns/mpls.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/net/netns/can.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/ns_common.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/seq_file_net.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/net/netprio_cgroup.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/cgroup.h \
    $(wildcard include/config/sock/cgroup/data.h) \
    $(wildcard include/config/cgroup/net/classid.h) \
    $(wildcard include/config/cgroup/data.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/cgroupstats.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/taskstats.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/nsproxy.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/user_namespace.h \
    $(wildcard include/config/inotify/user.h) \
    $(wildcard include/config/persistent/keyrings.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/cgroup-defs.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/bpf-cgroup.h \
    $(wildcard include/config/cgroup/bpf.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/bpf.h \
    $(wildcard include/config/efficient/unaligned/access.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/bpf_common.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/cgroup_subsys.h \
    $(wildcard include/config/cgroup/cpuacct.h) \
    $(wildcard include/config/blk/cgroup.h) \
    $(wildcard include/config/cgroup/device.h) \
    $(wildcard include/config/cgroup/freezer.h) \
    $(wildcard include/config/cgroup/perf.h) \
    $(wildcard include/config/cgroup/hugetlb.h) \
    $(wildcard include/config/cgroup/pids.h) \
    $(wildcard include/config/cgroup/rdma.h) \
    $(wildcard include/config/cgroup/debug.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/neighbour.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/netlink.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/net/scm.h \
    $(wildcard include/config/security/network.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/security.h \
    $(wildcard include/config/security/infiniband.h) \
    $(wildcard include/config/security/network/xfrm.h) \
    $(wildcard include/config/security/path.h) \
    $(wildcard include/config/audit.h) \
    $(wildcard include/config/securityfs.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/netlink.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/netdevice.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/if_link.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/if_link.h \
    $(wildcard include/config/pending.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/if_bonding.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/pkt_cls.h \
    $(wildcard include/config/net/cls/ind.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/pkt_sched.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/hashtable.h \
  arch/arm64/include/generated/asm/unaligned.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/asm-generic/unaligned.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/unaligned/access_ok.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/unaligned/generic.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/input-polldev.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/input.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/input.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/input-event-codes.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/mod_devicetable.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/kfifo.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/average.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/usb.h \
    $(wildcard include/config/usb/mon.h) \
    $(wildcard include/config/acpi.h) \
    $(wildcard include/config/usb/led/trig.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/usb/ch9.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/usb/ch9.h \
    $(wildcard include/config/size.h) \
    $(wildcard include/config/att/one.h) \
    $(wildcard include/config/att/selfpower.h) \
    $(wildcard include/config/att/wakeup.h) \
    $(wildcard include/config/att/battery.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/pm_runtime.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/clk.h \
    $(wildcard include/config/common/clk.h) \
    $(wildcard include/config/have/clk/prepare.h) \
    $(wildcard include/config/have/clk.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/net/mac80211.h \
    $(wildcard include/config/mac80211/debugfs.h) \
    $(wildcard include/config/type/restart.h) \
    $(wildcard include/config/type/suspend.h) \
    $(wildcard include/config/nl80211/testmode.h) \
    $(wildcard include/config/mac80211/leds.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/ieee80211.h \
    $(wildcard include/config/timeout.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/net/cfg80211.h \
    $(wildcard include/config/cfg80211.h) \
    $(wildcard include/config/cfg80211/wext.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/debugfs.h \
    $(wildcard include/config/debug/fs.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/nl80211.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/net/regulatory.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/net/codel.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/net/pkt_sched.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/if_vlan.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/rtnetlink.h \
    $(wildcard include/config/net/ingress.h) \
    $(wildcard include/config/net/egress.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/rtnetlink.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/if_addr.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/if_vlan.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/net/sch_generic.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/pkt_cls.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/net/gen_stats.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/gen_stats.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/net/rtnetlink.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/net/netlink.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/pkt_sched.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/net/inet_ecn.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/ip.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/ip.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/net/inet_sock.h \
    $(wildcard include/config/inet.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/net/sock.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/page_counter.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/memcontrol.h \
    $(wildcard include/config/memcg/swap.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/vmpressure.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/eventfd.h \
    $(wildcard include/config/eventfd.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/writeback.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/flex_proportions.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/backing-dev-defs.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/blk_types.h \
    $(wildcard include/config/blk/dev/throttling/low.h) \
    $(wildcard include/config/blk/dev/integrity.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/bvec.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/bio.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/highmem.h \
    $(wildcard include/config/x86/32.h) \
    $(wildcard include/config/debug/highmem.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/arch/arm64/include/asm/cacheflush.h \
  arch/arm64/include/generated/asm/kmap_types.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/asm-generic/kmap_types.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/mempool.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/ioprio.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/iocontext.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/filter.h \
    $(wildcard include/config/arch/has/set/memory.h) \
    $(wildcard include/config/bpf/jit.h) \
    $(wildcard include/config/have/ebpf/jit.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/cryptohash.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/set_memory.h \
  arch/arm64/include/generated/asm/set_memory.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/asm-generic/set_memory.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/filter.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/rculist_nulls.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/poll.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/poll.h \
  arch/arm64/include/generated/uapi/asm/poll.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/asm-generic/poll.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/net/dst.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/net/neighbour.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/net/tcp_states.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/net_tstamp.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/net/smc.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/net/request_sock.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/net/netns/hash.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/net/l3mdev.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/net/fib_rules.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/fib_rules.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/net/fib_notifier.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/net/dsfield.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/ipv6.h \
    $(wildcard include/config/ipv6/router/pref.h) \
    $(wildcard include/config/ipv6/route/info.h) \
    $(wildcard include/config/ipv6/optimistic/dad.h) \
    $(wildcard include/config/ipv6/seg6/hmac.h) \
    $(wildcard include/config/ipv6/mip6.h) \
    $(wildcard include/config/ipv6/subtrees.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/ipv6.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/icmpv6.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/icmpv6.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/tcp.h \
    $(wildcard include/config/tcp/md5sig.h) \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/win_minmax.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/net/inet_connection_sock.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/net/inet_timewait_sock.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/net/timewait_sock.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/tcp.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/linux/udp.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/include/uapi/linux/udp.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/drivers/net/wireless/ralink/rt2x00/rt2x00debug.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/drivers/net/wireless/ralink/rt2x00/rt2x00dump.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/drivers/net/wireless/ralink/rt2x00/rt2x00leds.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/drivers/net/wireless/ralink/rt2x00/rt2x00reg.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/drivers/net/wireless/ralink/rt2x00/rt2x00queue.h \
  /home/forlinx/work/OK10xx-linux-fs/flexbuild/packages/linux/OK10xx-linux-kernel/drivers/net/wireless/ralink/rt2x00/rt2x00lib.h \
    $(wildcard include/config/rt2x00/lib/firmware.h) \

drivers/net/wireless/ralink/rt2x00/rt2x00config.o: $(deps_drivers/net/wireless/ralink/rt2x00/rt2x00config.o)

$(deps_drivers/net/wireless/ralink/rt2x00/rt2x00config.o):
