# write 1MB 1024 times
sudo dd if=/dev/zero of=/mnt/volume/tempfile bs=1M count=1024 conv=fdatasync,notrunc

# empty the cache
echo 3 | sudo tee /proc/sys/vm/drop_caches

# read 1MB 1024 times
sudo dd if=/mnt/volume/tempfile of=/dev/null bs=1M count=1024