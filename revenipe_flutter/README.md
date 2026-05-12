# revenipe_flutter

Base Flutter SDK for Revenipe.

This package now exposes a stronger core foundation centered around:

- a single public SDK facade (`Revenipe.instance`)
- immutable configuration (`RevenipeConfig`)
- typed network transport
- typed SDK exceptions
- session handling for the currently identified user
- clean internal boundaries for future entitlement and usage APIs

## Current usage

```dart
import 'package:revenipe_flutter/revenipe_flutter.dart';

final revenipe = Revenipe.instance;

await revenipe.configure(
  config: const RevenipeConfig(
    appId: 'app_123',
  ),
);

final user = await revenipe.login('client_123');
print(user.userId);
```

## Included core pieces

- `Revenipe`
- `RevenipeConfig`
- `RevenipeSession`
- `RevenipeException`
- `RevenipeUser`
- entitlement models

## Next recommended layer

After this base, the next clean additions are:

1. entitlement fetch APIs
2. usage consume APIs
3. caching / persistence
4. request interceptors for session-bound flows
