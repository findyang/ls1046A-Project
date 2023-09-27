#include <linux/module.h>
#include <linux/vermagic.h>
#include <linux/compiler.h>

MODULE_INFO(vermagic, VERMAGIC_STRING);
MODULE_INFO(name, KBUILD_MODNAME);

__visible struct module __this_module
__attribute__((section(".gnu.linkonce.this_module"))) = {
	.name = KBUILD_MODNAME,
	.arch = MODULE_ARCH_INIT,
};

MODULE_INFO(intree, "Y");

#ifdef RETPOLINE
MODULE_INFO(retpoline, "Y");
#endif

static const struct modversion_info ____versions[]
__used
__attribute__((section("__versions"))) = {
	{ 0x59cc993a, __VMLINUX_SYMBOL_STR(module_layout) },
	{ 0x84f1b4f4, __VMLINUX_SYMBOL_STR(kmalloc_caches) },
	{ 0x9a908b80, __VMLINUX_SYMBOL_STR(test_and_clear_bit) },
	{ 0xd2b09ce5, __VMLINUX_SYMBOL_STR(__kmalloc) },
	{ 0xf9a482f9, __VMLINUX_SYMBOL_STR(msleep) },
	{ 0xc647ee87, __VMLINUX_SYMBOL_STR(hrtimer_cancel) },
	{ 0x88bfa7e, __VMLINUX_SYMBOL_STR(cancel_work_sync) },
	{ 0xb7d5bbaa, __VMLINUX_SYMBOL_STR(usb_kill_urb) },
	{ 0xfd3dde7b, __VMLINUX_SYMBOL_STR(rt2x00lib_resume) },
	{ 0xeae3dfd6, __VMLINUX_SYMBOL_STR(__const_udelay) },
	{ 0x4aacd53e, __VMLINUX_SYMBOL_STR(mutex_unlock) },
	{ 0xa87cf413, __VMLINUX_SYMBOL_STR(clear_bit) },
	{ 0x526c3a6c, __VMLINUX_SYMBOL_STR(jiffies) },
	{ 0x7f56d888, __VMLINUX_SYMBOL_STR(usb_unanchor_urb) },
	{ 0xc2b00af2, __VMLINUX_SYMBOL_STR(__init_waitqueue_head) },
	{ 0xd3259d65, __VMLINUX_SYMBOL_STR(test_and_set_bit) },
	{ 0x3878d05f, __VMLINUX_SYMBOL_STR(dev_err) },
	{ 0x293334b9, __VMLINUX_SYMBOL_STR(rt2x00lib_dmastart) },
	{ 0x880bb327, __VMLINUX_SYMBOL_STR(rt2x00queue_flush_queue) },
	{ 0xa108b8de, __VMLINUX_SYMBOL_STR(ieee80211_alloc_hw_nm) },
	{ 0x27e1a049, __VMLINUX_SYMBOL_STR(printk) },
	{ 0x13ff1ae6, __VMLINUX_SYMBOL_STR(usb_control_msg) },
	{ 0x8f3ea723, __VMLINUX_SYMBOL_STR(rt2x00queue_for_each_entry) },
	{ 0x5e38de65, __VMLINUX_SYMBOL_STR(mutex_lock) },
	{ 0xf717cf82, __VMLINUX_SYMBOL_STR(rt2x00queue_start_queue) },
	{ 0xc8ec9c8d, __VMLINUX_SYMBOL_STR(rt2x00lib_remove_dev) },
	{ 0x1e452cd2, __VMLINUX_SYMBOL_STR(usb_submit_urb) },
	{ 0xa171ab20, __VMLINUX_SYMBOL_STR(kmem_cache_alloc) },
	{ 0xd4aad54, __VMLINUX_SYMBOL_STR(usb_get_dev) },
	{ 0x718c43c6, __VMLINUX_SYMBOL_STR(usb_kill_anchored_urbs) },
	{ 0xd3ec543b, __VMLINUX_SYMBOL_STR(rt2x00queue_get_entry) },
	{ 0x87c57199, __VMLINUX_SYMBOL_STR(usb_reset_device) },
	{ 0x74895606, __VMLINUX_SYMBOL_STR(rt2x00lib_rxdone) },
	{ 0xb6aebbb7, __VMLINUX_SYMBOL_STR(usb_put_dev) },
	{ 0x37a0cba, __VMLINUX_SYMBOL_STR(kfree) },
	{ 0x4829a47e, __VMLINUX_SYMBOL_STR(memcpy) },
	{ 0xae8c4d0c, __VMLINUX_SYMBOL_STR(set_bit) },
	{ 0xf9790e69, __VMLINUX_SYMBOL_STR(hrtimer_init) },
	{ 0xeb579e6f, __VMLINUX_SYMBOL_STR(ieee80211_free_hw) },
	{ 0xf08d0ee4, __VMLINUX_SYMBOL_STR(dev_warn) },
	{ 0x98b893d9, __VMLINUX_SYMBOL_STR(rt2x00lib_txdone_noinfo) },
	{ 0x2e0d2f7f, __VMLINUX_SYMBOL_STR(queue_work_on) },
	{ 0x7f02188f, __VMLINUX_SYMBOL_STR(__msecs_to_jiffies) },
	{ 0x7bb2dd14, __VMLINUX_SYMBOL_STR(devm_kmalloc) },
	{ 0x70b0ecf6, __VMLINUX_SYMBOL_STR(rt2x00lib_dmadone) },
	{ 0x56157f4a, __VMLINUX_SYMBOL_STR(usb_free_urb) },
	{ 0x6065a66c, __VMLINUX_SYMBOL_STR(rt2x00lib_probe_dev) },
	{ 0x87271979, __VMLINUX_SYMBOL_STR(rt2x00queue_stop_queue) },
	{ 0x2ae21120, __VMLINUX_SYMBOL_STR(rt2x00lib_suspend) },
	{ 0x6a2a9eb9, __VMLINUX_SYMBOL_STR(usb_anchor_urb) },
	{ 0xa3a671a8, __VMLINUX_SYMBOL_STR(__skb_pad) },
	{ 0x6f2d4ce5, __VMLINUX_SYMBOL_STR(usb_alloc_urb) },
};

static const char __module_depends[]
__used
__attribute__((section(".modinfo"))) =
"depends=rt2x00lib,mac80211";


MODULE_INFO(srcversion, "2F6CBEA3CBDE90DC58E22EF");
