const os = require('os');

console.log('User login:', os.userInfo().username);
const platform = os.platform();
let osLabel = 'Unknown';
switch (platform) {
case 'darwin':
	osLabel = 'Mac';
	break;
case 'win32':
	osLabel = 'Windows';
	break;
case 'linux':
	osLabel = 'Linux';
	break;
default:
	osLabel = platform;
}
console.log('OS :', osLabel);
console.log('Platform :', platform);
console.log('Architecture :', os.arch());
