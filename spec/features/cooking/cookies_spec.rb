feature 'Cooking cookies' do
  scenario 'Cooking a single cookie' do
    user = create_and_signin
    oven = user.ovens.first

    visit oven_path(oven)

    expect(page).to_not have_content 'Chocolate Chip'
    expect(page).to_not have_content 'Your Cookie is Ready'

    click_link_or_button 'Prepare Cookie'
    fill_in 'Fillings', with: 'Chocolate Chip'
    click_button 'Mix and bake'

    expect(current_path).to eq(oven_path(oven))
    expect(page).to have_content 'Chocolate Chip'
  end

  scenario "retrieve" do
    user = create_and_signin
    oven = user.ovens.first
    FactoryGirl.create(:cookie, storage: oven, state: :cooked, fillings: 'Chocolate Chip')
    visit oven_path(oven)
    expect(page).to have_content 'Chocolate Chip'
    click_button 'Retrieve Cookie'
    expect(page).to_not have_content 'Chocolate Chip'
  end

  scenario 'Trying to bake a cookie while oven is full' do
    user = create_and_signin
    oven = user.ovens.first

    oven = FactoryGirl.create(:oven, user: user)
    visit oven_path(oven)

    click_link_or_button 'Prepare Cookie'
    fill_in 'Fillings', with: 'Chocolate Chip'
    click_button 'Mix and bake'

    click_link_or_button  'Prepare Cookie'
    expect(page).to have_content 'Cookies are already in the oven! (Total: 1)'
    expect(current_path).to eq(oven_path(oven))
    expect(page).to_not have_button 'Mix and bake'
  end

  scenario 'Baking multiple cookies' do
    user = create_and_signin
    oven = user.ovens.first

    oven = FactoryGirl.create(:oven, user: user)
    visit oven_path(oven)

    click_link_or_button 'Prepare Cookie'
    fill_in 'Fillings', with: 'Chocolate Chip'
    fill_in 'total_cookies', with: '3'
    click_button 'Mix and bake'
  end
end
