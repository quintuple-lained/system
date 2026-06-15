{
	disko.devices = {
		disk = {
			main = {
				type = "disk";
				device = "tbd";
				content = {
					type = "gpt";
					partitions = {
						ESP = {
							size = "500M";
							type = "EF00";
							content = {
								type = "filesystem";
								format = "vfat";
								mountpoint = "/boot";
								mountOptions = [ "umask=0077" ];
							};
						};
						encryptedSwap = {
							size = "16G";
							content = {
								type = "swap";
								randomEncryption = true;
								priority = 100;
							};
						};
						luks = {
							size = "100%";
							content = {
								type = "luks";
								name = "crypt_root";
								settings.allowDiscards = true;
								enrollFido2 = true;
								enrollRecovery = talse;
								content = {
									type = "filesystem";
									format = "xfs";
									mountpoint = "/";
								};
							};
						};
					};
				};
			};
		};
	};
};
