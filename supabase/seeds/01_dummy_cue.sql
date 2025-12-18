-- Seed: one dummy cue + actions + deterministic actions
-- Mirrors the React frontend dummy data.

-- Cue
insert into public.cues (id, title, description, created_by, created_at, updated_at)
values (
  '00000000-0000-0000-0000-000000000123',
  'Create purchase quote for Macbook ',
  'This is a sample cue description.',
  null,
  now(),
  now()
)
on conflict (id) do nothing;

-- Actions
insert into public.actions (id, cue_id, order_index, action_type, semantic_instruction, payload, created_at)
values
  (
    '00000000-0000-0000-0000-0000000000a0',
    '00000000-0000-0000-0000-000000000123',
    0,
    'NAVIGATE'::public.action_type,
    'Navigate to https://www.apple.com/',
    jsonb_build_object('destinationUrl', 'https://www.apple.com/'),
    to_timestamp(1697055540000 / 1000.0)
  ),
  (
    '00000000-0000-0000-0000-0000000000a1',
    '00000000-0000-0000-0000-000000000123',
    1,
    'CLICK'::public.action_type,
    'Click the ''Mac'' link in the header.',
    jsonb_build_object(
      'cursorPosition', jsonb_build_object(
        'clientX', 100,
        'clientY', 200,
        'viewportWidth', 1280,
        'viewportHeight', 720
      )
    ),
    to_timestamp(1697055600000 / 1000.0)
  ),
  (
    '00000000-0000-0000-0000-0000000000a2',
    '00000000-0000-0000-0000-000000000123',
    2,
    'CLICK'::public.action_type,
    'Click the ''Macbook Pro'' option from the dropdown.',
    jsonb_build_object(
      'cursorPosition', jsonb_build_object(
        'clientX', 150,
        'clientY', 250,
        'viewportWidth', 1280,
        'viewportHeight', 720
      )
    ),
    to_timestamp(1697055670000 / 1000.0)
  ),
  (
    '00000000-0000-0000-0000-0000000000a3',
    '00000000-0000-0000-0000-000000000123',
    3,
    'NAVIGATE'::public.action_type,
    'Navigate to https://www.bing.com/',
    jsonb_build_object('destinationUrl', 'https://www.bing.com/'),
    to_timestamp(1697055680000 / 1000.0)
  ),
  (
    '00000000-0000-0000-0000-0000000000a4',
    '00000000-0000-0000-0000-000000000123',
    4,
    'CLICK'::public.action_type,
    'Click the ''Sign in'' link in the header.',
    jsonb_build_object(
      'cursorPosition', jsonb_build_object(
        'clientX', 100,
        'clientY', 200,
        'viewportWidth', 1280,
        'viewportHeight', 720
      )
    ),
    to_timestamp(1697055900000 / 1000.0)
  ),
  (
    '00000000-0000-0000-0000-0000000000a5',
    '00000000-0000-0000-0000-000000000123',
    5,
    'INPUT_TEXT'::public.action_type,
    'Enter ''testuser@gmail.com'' in the email field.',
    jsonb_build_object('inputValue', 'testuser@gmail.com'),
    to_timestamp(1697057000000 / 1000.0)
  )
on conflict (id) do nothing;

-- Deterministic actions (normalized from frontend deterministicAction)
insert into public.deterministic_actions (action_id, description, method, selector, arguments, validated, updated_at)
values
  (
    '00000000-0000-0000-0000-0000000000a1',
    'Link in the header navigation with the label ''Mac''',
    'click',
    'xpath=/html[1]/body[1]/div[1]/nav[1]/div[1]/ul[1]/li[2]/div[1]/div[1]/div[2]/ul[1]/li[1]/a[1]',
    array[]::text[],
    true,
    to_timestamp(1697055600000 / 1000.0)
  ),
  (
    '00000000-0000-0000-0000-0000000000a2',
    'Link element labeled ''MacBook Pro'' in the Mac Family of products section.',
    'click',
    'xpath=/html[1]/body[1]/div[1]/div[1]/main[1]/nav[1]/div[1]/ul[1]/li[3]/a[1]',
    array[]::text[],
    true,
    to_timestamp(1697055670000 / 1000.0)
  ),
  (
    '00000000-0000-0000-0000-0000000000a3',
    'Navigate to https://www.bing.com/',
    'navigate',
    'html',
    array['https://www.bing.com/'],
    true,
    to_timestamp(1697055680000 / 1000.0)
  ),
  (
    '00000000-0000-0000-0000-0000000000a4',
    'Link for signing in to the account, labeled ''Sign in'' in the header section.',
    'click',
    'xpath=/html[1]/body[1]/div[1]/div[1]/div[3]/header[1]/div[2]/div[1]/div[1]/a[1]',
    array[]::text[],
    true,
    to_timestamp(1697055900000 / 1000.0)
  ),
  (
    '00000000-0000-0000-0000-0000000000a5',
    'Textbox for entering Email or phone number',
    'fill',
    'xpath=/html[1]/body[1]/div[1]/div[1]/div[1]/div[1]/div[1]/div[1]/div[1]/div[1]/div[1]/div[1]/div[1]/form[1]/div[2]/div[1]/div[2]/div[1]/div[1]/span[1]/input[1]',
    array['testuser@gmail.com'],
    true,
    to_timestamp(1697057000000 / 1000.0)
  )
on conflict (action_id) do nothing;
