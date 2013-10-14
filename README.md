BBEnterpriseUpdater
===
**Updater for Apple Enterprise app deployments.**

## Usage

```objective-c
[BBEnterpriseUpdater checkVersionWithURL:[NSURL URLWithString:@"http://example.com/BBUpdaterExample.plist"]
                                 success:^(BOOL requiresUpdate, NSString *versionString, NSURL *updateURL) {
                                     if (requiresUpdate) {
                                     	// See if the user wants to update to the latest version
                                     }
                                 } failure:^(NSError *error) {
                                     
                                 }];

```

## Contact

Eli Perkins

- http://github.com/eliperkins
- http://twitter.com/_eliperkins
- eli@onemightyroar.com

## License

BBEnterpriseUpdater is available under the MIT license. See the LICENSE file for more info.

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/eliperkins/bbenterpriseupdater/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

