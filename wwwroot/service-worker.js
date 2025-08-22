// In development, always fetch from the network and do not enable offline support.
// This is because caching would make development more difficult (changes would not
// be reflected on the first load after each change).

// For production builds, we need to ensure cache is properly managed
self.addEventListener('install', event => {
    // Skip waiting to activate the new service worker immediately
    self.skipWaiting();
});

self.addEventListener('activate', event => {
    // Take control immediately
    event.waitUntil(clients.claim());
});

self.addEventListener('fetch', event => {
    // In development mode, always fetch from network
    if (event.request.url.includes('localhost') || event.request.url.includes('127.0.0.1')) {
        event.respondWith(fetch(event.request));
        return;
    }
    
    // For production, implement cache-first strategy with cache busting
    event.respondWith(
        caches.open('blazor-cache-v1').then(cache => {
            return cache.match(event.request).then(cachedResponse => {
                // Check if we have a cached version
                if (cachedResponse) {
                    // Fetch from network in background to update cache
                    fetch(event.request).then(fetchResponse => {
                        if (fetchResponse && fetchResponse.status === 200) {
                            cache.put(event.request, fetchResponse.clone());
                        }
                    }).catch(() => {
                        // Network failed, use cached version
                    });
                    return cachedResponse;
                }
                
                // Not in cache, fetch from network
                return fetch(event.request).then(fetchResponse => {
                    // Check if we received a valid response
                    if (!fetchResponse || fetchResponse.status !== 200 || fetchResponse.type !== 'basic') {
                        return fetchResponse;
                    }
                    
                    // Clone the response because it's a stream
                    const responseToCache = fetchResponse.clone();
                    cache.put(event.request, responseToCache);
                    return fetchResponse;
                });
            });
        })
    );
});
