
VERSION=$1

# Contants BEGIN
PHP_SO_52='/usr/lib/apache2/modules/libphp5_2.so'
PHP_SO_53='/usr/lib/apache2/modules/libphp5_3.so'

PHP_LIB_52='/usr/lib/php5/'
PHP_LIB_53='/usr/lib/php5.3/'
# Contants END

# Initialize vars based on param
if [ "$VERSION" == "2" ]; then
	echo "PHP Version 5.2 selected"
	PHP_SO=$PHP_SO_52
	PHP_LIB=$PHP_LIB_52
elif [ "$VERSION" == "3" ]; then
	echo "PHP Version 5.3 selected"
	PHP_SO=$PHP_SO_53
	PHP_LIB=$PHP_LIB_53
else
	echo "Invalid PHP Version"
	echo "Please enter '2' for PHP 5.2 or '3' for PHP 5.3"
	exit
fi
	

# Stop apache
/etc/init.d/apache2 stop

# Copy appropriate SO
echo "Copying $PHP_SO to /usr/lib/apache2/modules/libphp5.so"
cp $PHP_SO /usr/lib/apache2/modules/libphp5.so

# Recreate symlinks
echo "Recreating symlinks in /usr/bin/"
for LINK in php php-cgi php-config phpize
do
	rm /usr/bin/$LINK
	ln -s ${PHP_LIB}bin/$LINK /usr/bin/$LINK
done

# Restart apache
/etc/init.d/apache2 start

echo "Finished.  Exiting..."