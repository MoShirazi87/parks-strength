'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "e7a4035299c783c497c83edabb804c54",
"version.json": "148156be4a3ac7bc9f5b0c2e7eed2ac3",
"index.html": "a88471e2dc65495359ca5641f466326a",
"/": "a88471e2dc65495359ca5641f466326a",
"main.dart.js": "0d0e2de99961ae6f4b592da9960d7ef3",
"flutter.js": "f393d3c16b631f36852323de8e583132",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "1988d9b05d1c69e6760d10fd99960402",
"assets/AssetManifest.json": "c2841c1730c2d830634177d99267523b",
"assets/NOTICES": "a6892f7c527056b0606c6a4b16d78b40",
"assets/FontManifest.json": "c85edf511094fc3afd57b99280b39b02",
"assets/AssetManifest.bin.json": "cb32fdf7a2f608729e05574bfd4e60e8",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/packages/phosphor_flutter/lib/fonts/Phosphor-Duotone.ttf": "e0b028909550eda3023ac5765bf8c16a",
"assets/packages/phosphor_flutter/lib/fonts/Phosphor-Fill.ttf": "612af00267f5e8a429531399700db66e",
"assets/packages/phosphor_flutter/lib/fonts/Phosphor.ttf": "c2ecd49d10b76c3f9b9c072966cc0c3c",
"assets/packages/phosphor_flutter/lib/fonts/Phosphor-Light.ttf": "6c53da4ecc310dd5dbcfafe3d916a346",
"assets/packages/phosphor_flutter/lib/fonts/Phosphor-Bold.ttf": "4f59e81563e413635c57d78338d33b92",
"assets/packages/phosphor_flutter/lib/fonts/Phosphor-Thin.ttf": "9ca0acf8bc84ec2421f96f835017f321",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "0301c6455d2d1fd13946dcd071ebdd9c",
"assets/fonts/MaterialIcons-Regular.otf": "644d928d9b269d4458e67ee2a815447c",
"assets/assets/exercises/kettlebell-swing.jpg": "903433aacd5908f80e1d6cdcd700ec78",
"assets/assets/exercises/bench-press.jpg": "b5577214c21a2dc20efecff6f52bbcad",
"assets/assets/exercises/shoulder-press.jpg": "a3e6cd4a0ff5fb59faf2c682d4bb66c3",
"assets/assets/exercises/leg-curl.jpg": "e8367cae0f58ad8de8985c918adb82d5",
"assets/assets/exercises/tricep-dip.jpg": "73dac4baab639888ec4db9f1350c4f7d",
"assets/assets/exercises/lat-pulldown.jpg": "ffc1932a51432c476ed1a8563ea52891",
"assets/assets/exercises/row.jpg": "f03277660223d640ba0ca85235678ee1",
"assets/assets/exercises/crunch.jpg": "21b13f55a4a90bbaffb528a090aa39b7",
"assets/assets/exercises/cable-fly.jpg": "e689bc1b3f5c397127b851949b66dc3e",
"assets/assets/exercises/barbell-curl.jpg": "0fbc4f566c62088cff7e3a84a5952a31",
"assets/assets/exercises/lunge.jpg": "c66524813e340c4b90b6e07d014887d7",
"assets/assets/exercises/dumbbell-press.jpg": "b2a82416ba297a3a6af2522a954abddc",
"assets/assets/exercises/dumbbell-curl.jpg": "0068e6346e9ec8563f7259c4442d7406",
"assets/assets/exercises/plank.jpg": "cc11a8088b2a026bef9b596e1b1c72bf",
"assets/assets/exercises/pull-up.jpg": "495376dd3632bdc0e6e0942e2304a92a",
"assets/assets/exercises/deadlift.jpg": "4487963f124aa02702ce38e4d57d83b6",
"assets/assets/exercises/calf-raise.jpg": "d37ef0cedbeb8181348568a5827fab6c",
"assets/assets/exercises/mountain-climber.jpg": "5251c1a98d83c99ebedf3857ce729057",
"assets/assets/exercises/squat.jpg": "3831199ea766c24a9faca78158ef6279",
"assets/assets/exercises/leg-press.jpg": "c7ee8428b14ceb33408c7e6090367a83",
"canvaskit/skwasm.js": "694fda5704053957c2594de355805228",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"canvaskit/chromium/canvaskit.js": "671c6b4f8fcc199dcc551c7bb125f239",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/canvaskit.js": "66177750aff65a66cb07bb44b8c6422b",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c"};
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
