#! /bin/bash

sed -i 's/nameserver 127.0.0.53/nameserver 1.1.1.1/g' /etc/resolv.conf && chattr +i /etc/resolv.conf

install_splunk() {
  # Check if Splunk is already installed
  if [ -f "/opt/splunk/bin/splunk" ]; then
    echo "[$(date +%H:%M:%S)]: Splunk is already installed"
  else
    # Get download.splunk.com into the DNS cache. Sometimes resolution randomly fails during wget below
    dig @8.8.8.8 download.splunk.com >/dev/null
    dig @8.8.8.8 splunk.com >/dev/null
    dig @8.8.8.8 www.splunk.com >/dev/null
    # Download Splunk
    echo "[$(date +%H:%M:%S)]: Downloading Splunk..."
    wget --progress=bar:force -O /opt/splunk-7.1.7-39ea4c097c30-linux-2.6-amd64.deb 'http://download.splunk.com/products/splunk/releases/7.1.7/linux/splunk-7.1.7-39ea4c097c30-linux-2.6-amd64.deb'
    # Install Splunk
    echo "[$(date +%H:%M:%S)]: Installing Splunk..."
    if ! ls /opt/splunk*.deb 1>/dev/null 2>&1; then
      echo "Something went wrong while trying to download Splunk. This script cannot continue. Exiting."
      exit 1
    fi
    if ! dpkg -i /opt/splunk*.deb >/dev/null; then
      echo "Something went wrong while trying to install Splunk. This script cannot continue. Exiting."
      exit 1
    fi

    # Start Splunk
    /opt/splunk/bin/splunk start --accept-license --answer-yes --no-prompt --seed-passwd changeme

    # Install TAs
    echo "[$(date +%H:%M:%S)]: Installing Splunk BOTSv3 Add-Ons..."
    /opt/splunk/bin/splunk install app /vagrant/resources/base64_11.tgz  -auth 'admin:changeme'
    /opt/splunk/bin/splunk install app /vagrant/resources/jellyfisher_010.tgz  -auth 'admin:changeme'
    /opt/splunk/bin/splunk install app /vagrant/resources/palo-alto-networks-add-on-for-splunk_620.tgz  -auth 'admin:changeme'
    /opt/splunk/bin/splunk install app /vagrant/resources/SA-ctf_scoreboard-master.zip  -auth 'admin:changeme'
    /opt/splunk/bin/splunk install app /vagrant/resources/sa-investigator-for-enterprise-security_200.tgz  -auth 'admin:changeme'
    /opt/splunk/bin/splunk install app /vagrant/resources/splunk-add-on-for-apache-web-server_100.tgz  -auth 'admin:changeme'
    /opt/splunk/bin/splunk install app /vagrant/resources/splunk-add-on-for-microsoft-iis_101.tgz  -auth 'admin:changeme'
    /opt/splunk/bin/splunk install app /vagrant/resources/splunk-ta-for-suricata_233.tgz  -auth 'admin:changeme'
    /opt/splunk/bin/splunk install app /vagrant/resources/ssl-certificate-checker_32.tgz  -auth 'admin:changeme'
    /opt/splunk/bin/splunk install app /vagrant/resources/website-monitoring_274.tgz  -auth 'admin:changeme'
    /opt/splunk/bin/splunk install app /vagrant/resources/amazon-guardduty-add-on-for-splunk_104.tgz -auth 'admin:changeme'
    /opt/splunk/bin/splunk install app /vagrant/resources/cisco-anyconnect-network-visibility-module-nvm-app-for-splunk_20187.tgz -auth 'admin:changeme'
    /opt/splunk/bin/splunk install app /vagrant/resources/code42-for-splunk_3012.tgz -auth 'admin:changeme'
    /opt/splunk/bin/splunk install app /vagrant/resources/decrypt_20.tgz -auth 'admin:changeme'
    /opt/splunk/bin/splunk install app /vagrant/resources/microsoft-365-app-for-splunk_301.tgz -auth 'admin:changeme'
    /opt/splunk/bin/splunk install app /vagrant/resources/microsoft-azure-add-on-for-splunk_202.tgz -auth 'admin:changeme'
    /opt/splunk/bin/splunk install app /vagrant/resources/osquery-app-for-splunk_060.tgz -auth 'admin:changeme'
    /opt/splunk/bin/splunk install app /vagrant/resources/splunk-add-on-for-amazon-web-services_500.tgz -auth 'admin:changeme'
    /opt/splunk/bin/splunk install app /vagrant/resources/splunk-add-on-for-cisco-asa_340.tgz -auth 'admin:changeme'
    /opt/splunk/bin/splunk install app /vagrant/resources/splunk-add-on-for-microsoft-cloud-services_401.tgz -auth 'admin:changeme'
    /opt/splunk/bin/splunk install app /vagrant/resources/splunk-add-on-for-microsoft-office-365_201.tgz -auth 'admin:changeme'
    /opt/splunk/bin/splunk install app /vagrant/resources/splunk-add-on-for-microsoft-sysmon_1062.tgz -auth 'admin:changeme'
    /opt/splunk/bin/splunk install app /vagrant/resources/splunk-add-on-for-microsoft-windows_700.tgz -auth 'admin:changeme'
    /opt/splunk/bin/splunk install app /vagrant/resources/splunk-add-on-for-symantec-endpoint-protection_301.tgz -auth 'admin:changeme'
    /opt/splunk/bin/splunk install app /vagrant/resources/splunk-add-on-for-tenable_514.tgz -auth 'admin:changeme'
    /opt/splunk/bin/splunk install app /vagrant/resources/splunk-add-on-for-unix-and-linux_701.tgz -auth 'admin:changeme'
    /opt/splunk/bin/splunk install app /vagrant/resources/splunk-common-information-model-cim_4150.tgz -auth 'admin:changeme'
    /opt/splunk/bin/splunk install app /vagrant/resources/splunk-es-content-update_1052.tgz -auth 'admin:changeme'
    /opt/splunk/bin/splunk install app /vagrant/resources/splunk-security-essentials_306.tgz -auth 'admin:changeme'
    /opt/splunk/bin/splunk install app /vagrant/resources/splunk-stream_720.tgz -auth 'admin:changeme'
    /opt/splunk/bin/splunk install app /vagrant/resources/ta-for-code42-app-for-splunk_3012.tgz -auth 'admin:changeme'
    /opt/splunk/bin/splunk install app /vagrant/resources/url-toolbox_18.tgz -auth 'admin:changeme'
    /opt/splunk/bin/splunk install app /vagrant/resources/virustotal-workflow-actions-for-splunk_020.tgz -auth 'admin:changeme'

    echo "[$(date +%H:%M:%S)]: Downloading Splunk BOTSv3 Attack Only Dataset..."
    wget --progress=bar:force -P /opt/ https://botsdataset.s3.amazonaws.com/botsv3/botsv3_data_set.tgz

    echo "[$(date +%H:%M:%S)]: Extracting to Splunk Apps directory..."
    tar zxvf /opt/botsv3_data_set.tgz -C /opt/splunk/etc/apps/

    echo "[$(date +%H:%M:%S)]: BOTSv3 Installation complete!"

    # Skip Splunk Tour and Change Password Dialog
    echo "[$(date +%H:%M:%S)]: Disabling the Splunk tour prompt..."
    touch /opt/splunk/etc/.ui_login
    mkdir -p /opt/splunk/etc/users/admin/search/local
    echo -e "[search-tour]\nviewed = 1" >/opt/splunk/etc/system/local/ui-tour.conf
    # Source: https://answers.splunk.com/answers/660728/how-to-disable-the-modal-pop-up-help-us-to-improve.html
    if [ ! -d "/opt/splunk/etc/users/admin/user-prefs/local" ]; then
      mkdir -p "/opt/splunk/etc/users/admin/user-prefs/local"
    fi
    echo '[general]
render_version_messages = 1
dismissedInstrumentationOptInVersion = 4
notification_python_3_impact = false' > /opt/splunk/etc/users/admin/user-prefs/local/user-prefs.conf

    # Reboot Splunk to make changes take effect
    echo "[$(date +%H:%M:%S)]: Restarting Splunk..."
    /opt/splunk/bin/splunk restart
    /opt/splunk/bin/splunk enable boot-start
  fi
}

postinstall_tasks() {
  # Include Splunk in the PATH
  echo export PATH="$PATH:/opt/splunk/bin" >>~/.bashrc
  echo "export SPLUNK_HOME=/opt/splunk" >>~/.bashrc
}

main() {
  install_splunk
  postinstall_tasks
}

main
exit 0