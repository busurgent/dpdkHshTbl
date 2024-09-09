#include <stdio.h>
#include <rte_time.h>
#include <rte_hash.h>
#include <rte_errno.h>
#include <rte_random.h>
#include <rte_jhash.h>

#define THE_NUMBER 16000000
#define OTHER_NUMBER 1000000
#define MAGIC_NUMBER 123456ul

int main(int argc, char *argv[]) {
    int ret = rte_eal_init(argc, argv);
    struct rte_hash *hash;
    struct rte_hash_parameters p = {0};
    struct rte_timecounter tc;
    uint64_t current_ns;
    uint64_t hz = rte_get_timer_hz();
    int count;
    void *ans;
    uint64_t key = 42;
    uint64_t start, end;
    int index;

    if (ret < 0) 
        rte_panic("Cannot init EAL...\n");

    p.name = "hash";
    p.entries = OTHER_NUMBER;
    p.key_len = sizeof(uint64_t);
    p.hash_func = rte_jhash;
    hash = rte_hash_create(&p);
    if (!hash) {
        rte_panic("Failed to create hash table\n");
        return -1;
    }

    // Инициализация структуры timecounter
    tc.nsec = 0;
    tc.nsec_mask = NSEC_PER_SEC - 1; // Маска для выделения наносекунд
    tc.nsec_frac = 0;
    tc.cc_mask = UINT64_MAX; // Маска для вычитания
    tc.cc_shift = __builtin_ctzll(hz); // Сдвиг для циклов в наносекунды
    tc.cycle_last = rte_get_timer_cycles();


    for (int i = 0; i < THE_NUMBER; i++) {
        uint64_t key;
        uint64_t *data = malloc(sizeof(uint64_t));
        *data = rte_rand();
        key = rte_rand();

        if (i == MAGIC_NUMBER) {
            key = 42;
            *data = MAGIC_NUMBER;
        }

        ret = rte_hash_add_key_data(hash, &key, data);

        // if (ret < 0) {
        //     printf("Failed to add key %lu at iteration %d, error code: %d\n", key, i, ret);
        // }

        if (i % OTHER_NUMBER == 0) {
            current_ns = rte_timecounter_update(&tc, rte_get_timer_cycles());
            printf("%d k / %d k, time: %ld ns\n", i / 1000, THE_NUMBER / 1000, current_ns);
        }
    }

    count = rte_hash_count(hash);


    start = rte_get_timer_cycles();
    index = rte_hash_lookup_data(hash, &key, &ans);
    end = rte_get_timer_cycles();


    if (index >= 0) {
            printf("Hash size: %d, key: %lu, hash idx: %d, data: %lu, lookup time: %ld ns\n", 
                count, key, index, *(uint64_t*)ans, rte_cyclecounter_cycles_to_ns(&tc, end - start));
    } else {
        printf("Key not found. Lookup index: %d, error code: %d\n", index, rte_errno);
    }

    rte_hash_free(hash);
    rte_eal_cleanup();
    return 0;
}
