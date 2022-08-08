module.exports = ({ env }) => ({
  auth: {
    secret: env('ADMIN_JWT_SECRET', 'c9fa5203bc3fe8554798a64424e9e20c'),
  },
});
