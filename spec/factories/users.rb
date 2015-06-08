FactoryGirl.define do
  factory :user1, :class => User do
    full_name 'Temp User1'
    email 'temp1@test.com'
    encrypted_password '$2a$10$sMxH4S0VZ09ET8dESTYVYOCoS7iDYYUAHbatxLFQDdW92pRcNfRp2'
    reset_password_token 'eaz5U46YxR5f-5epRyav'
    sign_in_count 32
    last_sign_in_at '2015-06-08 04:51:43.000000000 Z'
    current_sign_in_ip '127.0.0.1'
    last_sign_in_ip '127.0.0.1'
    confirmed_at '2015-05-25 10:51:04.000000000 Z'
    confirmation_sent_at '2015-05-25 10:50:14.000000000 Z'
  end
  factory :user2, :class => User do
    full_name 'Temp User2'
    email 'temp2@test.com'
    encrypted_password '$2a$10$GiwJFR8T89iTkhClYD6yY.DBwsr65TkyCSvu5qVRaAKd6De0qeFp2'
    reset_password_token 'd13fb692fda208aea97d26ce443c63f57efc532f65ad1482488996e62626492b'
    sign_in_count 4
    last_sign_in_at '2015-06-08 03:15:24.000000000 Z'
    current_sign_in_ip '127.0.0.1'
    last_sign_in_ip '127.0.0.1'
    confirmed_at '2015-05-26 10:56:24.000000000 Z'
    confirmation_sent_at '2015-06-05 10:03:55.000000000 Z'
  end
  factory :new_user, :class => User do
    email 'temp_new_user@test.com'
  end
end