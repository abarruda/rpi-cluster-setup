# Set time zone and time 
echo "America/Los_Angeles" > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata