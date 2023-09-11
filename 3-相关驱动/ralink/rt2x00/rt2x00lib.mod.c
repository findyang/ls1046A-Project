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
	{ 0xca70fdf, __VMLINUX_SYMBOL_STR(ieee80211_rx_napi) },
	{ 0x84f1b4f4, __VMLINUX_SYMBOL_STR(kmalloc_caches) },
	{ 0xd2b09ce5, __VMLINUX_SYMBOL_STR(__kmalloc) },
	{ 0x9a908b80, __VMLINUX_SYMBOL_STR(test_and_clear_bit) },
	{ 0xf33847d3, __VMLINUX_SYMBOL_STR(_raw_spin_unlock) },
	{ 0x97868aef, __VMLINUX_SYMBOL_STR(__kfifo_alloc) },
	{ 0xfcc61c8f, __VMLINUX_SYMBOL_STR(ieee80211_queue_work) },
	{ 0x43a53735, __VMLINUX_SYMBOL_STR(__alloc_workqueue_key) },
	{ 0x19f462ab, __VMLINUX_SYMBOL_STR(kfree_call_rcu) },
	{ 0x79aa04a2, __VMLINUX_SYMBOL_STR(get_random_bytes) },
	{ 0xf6f0ffed, __VMLINUX_SYMBOL_STR(_raw_spin_lock_bh) },
	{ 0xd8604f60, __VMLINUX_SYMBOL_STR(ieee80211_rts_get) },
	{ 0x6b06fdce, __VMLINUX_SYMBOL_STR(delayed_work_timer_fn) },
	{ 0xe364500c, __VMLINUX_SYMBOL_STR(ieee80211_beacon_get_tim) },
	{ 0x88bfa7e, __VMLINUX_SYMBOL_STR(cancel_work_sync) },
	{ 0xb81be668, __VMLINUX_SYMBOL_STR(ieee80211_unregister_hw) },
	{ 0xe8663ae6, __VMLINUX_SYMBOL_STR(ieee80211_channel_to_frequency) },
	{ 0xce8ef95b, __VMLINUX_SYMBOL_STR(__dev_kfree_skb_any) },
	{ 0xd8a7a48c, __VMLINUX_SYMBOL_STR(led_classdev_resume) },
	{ 0x5ee52022, __VMLINUX_SYMBOL_STR(init_timer_key) },
	{ 0x64af6747, __VMLINUX_SYMBOL_STR(cancel_delayed_work_sync) },
	{ 0x4aacd53e, __VMLINUX_SYMBOL_STR(mutex_unlock) },
	{ 0xd31b516f, __VMLINUX_SYMBOL_STR(ieee80211_iterate_active_interfaces_atomic) },
	{ 0xa87cf413, __VMLINUX_SYMBOL_STR(clear_bit) },
	{ 0xe96d6c98, __VMLINUX_SYMBOL_STR(wiphy_rfkill_start_polling) },
	{ 0x526c3a6c, __VMLINUX_SYMBOL_STR(jiffies) },
	{ 0xd5551ca0, __VMLINUX_SYMBOL_STR(skb_trim) },
	{ 0x53367e2, __VMLINUX_SYMBOL_STR(ieee80211_stop_queues) },
	{ 0xd2605a50, __VMLINUX_SYMBOL_STR(of_led_classdev_register) },
	{ 0x2192e86, __VMLINUX_SYMBOL_STR(__netdev_alloc_skb) },
	{ 0xaa83c88a, __VMLINUX_SYMBOL_STR(ieee80211_stop_queue) },
	{ 0x4eb78628, __VMLINUX_SYMBOL_STR(ieee80211_tx_status) },
	{ 0xd3259d65, __VMLINUX_SYMBOL_STR(test_and_set_bit) },
	{ 0xdcb764ad, __VMLINUX_SYMBOL_STR(memset) },
	{ 0x3878d05f, __VMLINUX_SYMBOL_STR(dev_err) },
	{ 0x97fdbab9, __VMLINUX_SYMBOL_STR(_raw_spin_unlock_irqrestore) },
	{ 0xe2eb0ddf, __VMLINUX_SYMBOL_STR(__mutex_init) },
	{ 0xb54b21de, __VMLINUX_SYMBOL_STR(ieee80211_free_txskb) },
	{ 0x3c3fce39, __VMLINUX_SYMBOL_STR(__local_bh_enable_ip) },
	{ 0x41e5e34f, __VMLINUX_SYMBOL_STR(skb_push) },
	{ 0x5e38de65, __VMLINUX_SYMBOL_STR(mutex_lock) },
	{ 0x8c03d20c, __VMLINUX_SYMBOL_STR(destroy_workqueue) },
	{ 0x9545af6d, __VMLINUX_SYMBOL_STR(tasklet_init) },
	{ 0x2469810f, __VMLINUX_SYMBOL_STR(__rcu_read_unlock) },
	{ 0x23eb6731, __VMLINUX_SYMBOL_STR(skb_pull) },
	{ 0x51c39079, __VMLINUX_SYMBOL_STR(ieee80211_ctstoself_get) },
	{ 0x6bc16522, __VMLINUX_SYMBOL_STR(wiphy_rfkill_stop_polling) },
	{ 0xb4c719f9, __VMLINUX_SYMBOL_STR(ieee80211_queue_delayed_work) },
	{ 0x82072614, __VMLINUX_SYMBOL_STR(tasklet_kill) },
	{ 0x6dba6098, __VMLINUX_SYMBOL_STR(of_get_mac_address) },
	{ 0x1f91ad77, __VMLINUX_SYMBOL_STR(_dev_info) },
	{ 0xa171ab20, __VMLINUX_SYMBOL_STR(kmem_cache_alloc) },
	{ 0xabbbd444, __VMLINUX_SYMBOL_STR(_raw_spin_unlock_bh) },
	{ 0x75090002, __VMLINUX_SYMBOL_STR(queue_delayed_work_on) },
	{ 0xcfa26107, __VMLINUX_SYMBOL_STR(wiphy_rfkill_set_hw_state) },
	{ 0x1ab5d281, __VMLINUX_SYMBOL_STR(ieee80211_get_buffered_bc) },
	{ 0x5cd885d5, __VMLINUX_SYMBOL_STR(_raw_spin_lock) },
	{ 0xf704a5c2, __VMLINUX_SYMBOL_STR(dummy_dma_ops) },
	{ 0x96220280, __VMLINUX_SYMBOL_STR(_raw_spin_lock_irqsave) },
	{ 0x7d99a0de, __VMLINUX_SYMBOL_STR(ieee80211_wake_queue) },
	{ 0xdb760f52, __VMLINUX_SYMBOL_STR(__kfifo_free) },
	{ 0x8f6b436a, __VMLINUX_SYMBOL_STR(ieee80211_get_hdrlen_from_skb) },
	{ 0xaa7168e4, __VMLINUX_SYMBOL_STR(ieee80211_register_hw) },
	{ 0xf5f2cda1, __VMLINUX_SYMBOL_STR(led_classdev_unregister) },
	{ 0x1eb9516e, __VMLINUX_SYMBOL_STR(round_jiffies_relative) },
	{ 0x37a0cba, __VMLINUX_SYMBOL_STR(kfree) },
	{ 0x4829a47e, __VMLINUX_SYMBOL_STR(memcpy) },
	{ 0x52d610df, __VMLINUX_SYMBOL_STR(ieee80211_tx_status_ext) },
	{ 0xae8c4d0c, __VMLINUX_SYMBOL_STR(set_bit) },
	{ 0xe83fbc3f, __VMLINUX_SYMBOL_STR(led_classdev_suspend) },
	{ 0x2de85c81, __VMLINUX_SYMBOL_STR(request_firmware) },
	{ 0xf08d0ee4, __VMLINUX_SYMBOL_STR(dev_warn) },
	{ 0x2e0d2f7f, __VMLINUX_SYMBOL_STR(queue_work_on) },
	{ 0x28318305, __VMLINUX_SYMBOL_STR(snprintf) },
	{ 0x5a9f1d63, __VMLINUX_SYMBOL_STR(memmove) },
	{ 0x5594772b, __VMLINUX_SYMBOL_STR(consume_skb) },
	{ 0x7f02188f, __VMLINUX_SYMBOL_STR(__msecs_to_jiffies) },
	{ 0x8d522714, __VMLINUX_SYMBOL_STR(__rcu_read_lock) },
	{ 0x7b90ccd6, __VMLINUX_SYMBOL_STR(skb_put) },
	{ 0x151f605f, __VMLINUX_SYMBOL_STR(ieee80211_iterate_interfaces) },
	{ 0x8b18773, __VMLINUX_SYMBOL_STR(release_firmware) },
};

static const char __module_depends[]
__used
__attribute__((section(".modinfo"))) =
"depends=mac80211,cfg80211";


MODULE_INFO(srcversion, "C4A00618AEE80BEBA0D90EC");
