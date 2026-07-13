# Avenue Seoul

A high-fidelity frontend MVP for a premium fashion e-commerce experience. It uses mock product data only and is structured for eventual Supabase and Razorpay integration.

## Run locally

1. Install Node.js 20+.
2. Run `npm install`.
3. Run `npm run dev` and open `http://localhost:3000`.

## Routes

- Customer storefront: `/`, `/shop`, `/product/av-001`, `/wishlist`, `/cart`, `/checkout`, `/login`, `/signup`, `/profile`, `/orders`
- Admin UI: `/admin`, `/admin/products`, `/admin/products/new`, plus categories, orders, customers, coupons, analytics, banners, and settings.

## Integration notes

Mock catalog data lives in `data/products.ts`; replace it with Supabase repository calls later. Checkout is intentionally visual-only; connect its order action to Razorpay only after server-side order creation is in place.
