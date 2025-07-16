INSERT INTO users (
  id,
  email,
  email_is_verified,
  mobile_phone,
  mobile_phone_is_verified,
  first_name,
  last_name,
  avatar,
  gender,
  user_role,
  hashed_password
) VALUES (
  '51e1e4ee-cd62-40d6-b079-a8573e06c116',
  'mahdad.ghasemian@gmail.com',
  FALSE,
  '+989129632744',
  FALSE,
  'Mahdad',
  'Ghasemian',
  NULL,
  'unknown',  -- match enum values exactly
  'admin',
  '506df263d48e6942f18d.327cd348ce2811a4478c0a821379f82c74c26fcbfe74b8533d7378e60d89e82d'
);
