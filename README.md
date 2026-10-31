# Paytimate POS - Mobile App Developer

A single-screen, offline-first Point-of-Sale prototype built for the Paytimate
Technologies mobile app developer . Browse a product catalog, search/filter it in real time, add items to a cart, and see the
running total update instantly — with the cart surviving app restarts even
with zero connectivity.

## Features

- **Product catalog** — 10 sample products across Beverages, Food, and Bakery categories.
- **Real-time search** — case-insensitive filtering by product name or category as you type.
- **Cart management** — tap to add, use +/- steppers to adjust quantity, swipe into a
  full cart sheet to review or remove items.
- **Dynamic total** — a sticky bottom bar shows live item count and total price.
- **Offline persistence** — the cart is saved to local storage (Hive) on every
  change and restored automatically the next time the app opens, even with no
  network connection.
- **Empty states** — friendly messaging for an empty cart and for a search
  with no matches.
- **Material 3 design** — clean spacing, rounded cards, and a themed color scheme.

## Tech stack

| Layer               | Choice                          |
|---------------------|----------------------------------|
| Framework           | Flutter (Dart)                   |
| State management    | Provider (`ChangeNotifier`)      |
| Offline persistence | Hive (`hive`, `hive_flutter`)    |
| UI                  | Material 3                       |

## Architecture & state management

The app follows a simple, explicit Provider-based architecture — no backend
is used, per the assignment scope.

```
lib/
├── main.dart                  # App entry point, Hive init, MultiProvider setup
├── models/
│   ├── product.dart           # Product model + static in-memory catalog
│   └── cart_item.dart         # Product + quantity wrapper
├── providers/
│   ├── cart_provider.dart     # Cart state (ChangeNotifier) + Hive persistence
│   └── search_provider.dart   # Search query + filtered product list
├── screens/
│   └── pos_screen.dart        # Main screen: search bar + product list + summary bar
└── widgets/
    ├── product_tile.dart      # Single product row with add/quantity controls
    ├── cart_summary_bar.dart  # Sticky bottom bar with total + "View Cart"
    └── cart_sheet.dart        # Draggable bottom sheet listing full cart
```

**Why Provider:** `CartProvider` and `SearchProvider` each extend
`ChangeNotifier` and are exposed via `MultiProvider` at the root of the app.
Widgets read state with `context.watch<T>()` when they need to rebuild on
change (e.g. the cart summary bar), and `context.read<T>()` inside callbacks
like button taps, where triggering an action is all that's needed. This keeps
state in one place per concern (cart vs. search) and avoids passing callbacks
down through every widget layer.

**Why offline-first matters here:** since Paytimate's product is an
offline-first POS, `CartProvider` treats the in-memory cart as the source of
truth for the UI, but mirrors every mutation to a local Hive box as a simple
list of `{productId, quantity}` entries. On startup, `loadFromDisk()` reopens
that box and rehydrates the cart against the in-memory product catalog before
the first frame renders — so a cashier's in-progress cart isn't lost if the
app is killed or the device loses power, with no network dependency at any
point.

## How to run

1. Make sure you have the [Flutter SDK](https://docs.flutter.dev/get-started/install) installed (`flutter --version` to check).
2. From the project root, install dependencies:
   ```
   flutter pub get
   ```
3. Run on a connected device or emulator:
   ```
   flutter run
   ```

No backend, API keys, or additional setup is required — the product catalog
is bundled in-app and the cart persists purely to local device storage.

## Possible next steps (out of scope for this prototype)

- Sync local cart/orders to a backend once connectivity is restored.
- Barcode scanning for adding products.
- Multi-cart / order-history support.
- Unit tests for `CartProvider` (add/remove/persist round-trip).
