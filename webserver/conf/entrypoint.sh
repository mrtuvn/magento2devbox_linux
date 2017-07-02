#!/usr/bin/env bash

run_unison () {
    local status=1

    while [ $status != 0 ]; do
        su - magento2 -c 'unison magento2'
        status=$?
    done
}

rm -rf /var/www/magento2/status.html
rm -rf /home/magento2/magento2/status.html
if [ -n $USE_SHARED_WEBROOT ]
then
    if [ $USE_SHARED_WEBROOT == "0" ]
    then

        # if using custom sources
        if [ "$(ls -A /home/magento2/magento2)" ] && [ ! "$(ls -A /var/www/magento2)" ]
        then
            echo "[IN PROGRESS] Sync Started." > /var/www/magento2/status.html
            sed -i 's/^\(\s*DirectoryIndex\s*\).*$/\1status.html/' /home/magento2/magento2/.htaccess
            cp /home/magento2/magento2/.htacces /var/www/magento2/
            chown magento2:magento2 /var/www/magento2/.htaccess
            service apache2 start

            while [ -f /home/magento2/magento2/sync-wait ]
            do
                echo .
                sleep 2
            done

            chown -R magento2:magento2 /var/www/magento2

            if [ -n $CREATE_SYMLINK_EE ]
            then
                if [ $CREATE_SYMLINK_EE == "1" ]
                then
                    mkdir -p $HOST_CE_PATH
                    ln -s /var/www/magento2/$EE_DIRNAME $HOST_CE_PATH/$EE_DIRNAME
                fi
            fi


            chmod +x /var/www/magento2/bin/magento

            sed -i 's/^\(\s*DirectoryIndex\s*\).*$/\1index.php/' /home/magento2/magento2/.htaccess
            sed -i 's/^\(\s*DirectoryIndex\s*\).*$/\1index.php/' /var/www/magento2/.htaccess
            
        else
            
        fi
    fi
fi

supervisord -n -c /etc/supervisord.conf
