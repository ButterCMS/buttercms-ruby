require 'spec_helper'

describe ButterCMS::Content do
  before do
    allow(ButterCMS).to receive(:token).and_return('test123')
    allow(ButterCMS).to receive(:request).and_return({
      "meta"=>{
        "next_page"=>2, 
        "previous_page"=>nil, 
        "count"=>2
        }, 
      "data"=>{
        "author"=>[
          { "name"=>"Charles Dickens"},
          { "name"=>"J.K. Rowling"}
        ]
      }
    })
    
    @response = ButterCMS::Content.list('slug', {
      page: 1,
      page_size: 2
    })
  end
  
  it "has meta and collection info" do
    expect(@response.meta.next_page).to eq(2)
    expect(@response.to_a.first.data.first).to eq('author')
    expect(@response.to_a.first.data.last.first).to have_attributes(
      name: "Charles Dickens"
    )
  end
end