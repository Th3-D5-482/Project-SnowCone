'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "b568b4497fad5fd2ec68fbf376e5eac0",
"assets/AssetManifest.bin.json": "f197fbf20277edc45aa0305b751b3386",
"assets/AssetManifest.json": "b04b721d939b60e178e282536140b672",
"assets/assets/images/album/10,000_reasons.png": "3e763a1e59fdc19b88fb5ca0234312bf",
"assets/assets/images/album/all_sons_and_daughters.png": "6e6740f8f3f1f87f913cd950604d8b73",
"assets/assets/images/album/always.png": "6c4f80e32bbff5046fd4e3a8696759eb",
"assets/assets/images/album/ariving.png": "093f2431738b38ff36052205980828e6",
"assets/assets/images/album/reckless_love.png": "1d4588f8463e38f2d1518f8920de1d25",
"assets/assets/images/album/way_maker.png": "8d3c20fe4a60c5632904ebaa7d71c5d3",
"assets/assets/images/genres/devotional.png": "58b20bc835dcd85a52ba41f14f120648",
"assets/assets/images/genres/gospel.png": "b3382fb245212ff89c73878fc444cd19",
"assets/assets/images/genres/praise.png": "064976feff3f6bb75d0f2b0a01fd9e8a",
"assets/assets/images/genres/worship.png": "dacbb74c20d21e60372c7f535082a35c",
"assets/assets/images/random/logo.png": "6c1c2966eceb0db12b85f42238818ced",
"assets/assets/images/random/logo2.png": "82eb2fe858493e6f432f79e65efc6aa6",
"assets/assets/images/random/me.png": "f9735f1628cc93395bd2b0f6a1d00088",
"assets/assets/images/random/Th3_D5_482.jpeg": "68d4a3f6fad3544dcc5259d38f5e8e25",
"assets/assets/images/random/welcome.png": "c2e6b80ef83528eda3501511449ea3e7",
"assets/assets/images/songs/10000_reasons.png": "86d90b45aba7eca12ec60afa97422154",
"assets/assets/images/songs/great_are_you_lord.png": "f57ea855e7df588648efd0440705acca",
"assets/assets/images/songs/holy_forever.png": "f8efd65d41fc3290700e4aefc6b88428",
"assets/assets/images/songs/how_great_is_our_god.png": "cf99888efc940a28f2b2ab54fa08694d",
"assets/assets/images/songs/reckless_love.png": "9b04f0d91134de76574ecd832033c930",
"assets/assets/images/songs/way_maker.png": "c464b72ea269576b4473a2e39bce224d",
"assets/assets/images/top_mixes/grace_and_redemption_mix.png": "41aedd574e040c02ad47d452c1abebd2",
"assets/assets/images/top_mixes/praise_and_power%2520_mix.png": "90f5d5ffdacd5ba28fef95ba995e7a38",
"assets/assets/images/top_mixes/reflection_and_surrender_mix.png": "9c75a63129f09e4df71a7f337e25d3c8",
"assets/assets/images/top_mixes/revival_and_fire_mix.png": "e9f5d132f4c54ceccb50fe7e0b9f073c",
"assets/assets/images/top_mixes/worship_and_wonder_mix.png": "7d89dd2c426877002aac654f5ded373a",
"assets/FontManifest.json": "5a32d4310a6f5d9a6b651e75ba0d7372",
"assets/fonts/MaterialIcons-Regular.otf": "e7069dfd19b331be16bed984668fe080",
"assets/NOTICES": "5cbaf0d4b168993620aad3e47f6b22d0",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "b93248a553f9e8bc17f1065929d5934b",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "4769f3245a24c1fa9965f113ea85ec2a",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "3ca5dc7621921b901d513cc1ce23788c",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "a2eb084b706ab40c90610942d98886ec",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"flutter_bootstrap.js": "767adbad07310ea9c189d43ce9726fb4",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "6050ecd400596b6ec56121843dc6e750",
"/": "6050ecd400596b6ec56121843dc6e750",
"main.dart.js": "df4b32b5f7d97eae38fdcbf8f1e03b56",
"manifest.json": "6858a767bc61f44ddcf96ba3905fea09",
"version.json": "794af03ad599eb48d29243c1d69873a8"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
