# frozen_string_literal: true

class PublicationsController < ApplicationController
  def index
    works = Portfolio.order(position: :asc).all
    @works = works.map do |item|
      {
        title: item.title,
        subtitle: item.sub_title,
        cover: item.cover_jpg.url || item.cover_webp.url,
        mobile_cover: item.mobile_cover_jpg.url || item.mobile_cover_webp.url,
        page_cover: item.page_cover.url,
        preview_url: helpers.pdf_view_url(item.pdf_file.url),
        download_url: item.pdf_file.url,
        width: "#{100 * item.pixel_width / 700}%",
        height: "#{100 * item.pixel_height / 900}%",
      }
    end

    publications = Publication.order(position: :asc).all
    @publications = publications.map do |item|
      {
        title: item.title,
        subtitle: item.sub_title,
        cover: item.cover_jpg.url || item.cover_webp.url,
        mobile_cover: item.mobile_cover_jpg.url || item.mobile_cover_webp,
        page_cover: item.page_cover.url,
        preview_url: helpers.pdf_view_url(item.pdf_file.url),
        download_url: item.pdf_file.url,
        width: "#{100 * item.pixel_width / 700}%",
        height: "#{100 * item.pixel_height / 900}%",
        category: item.category_status,
      }
    end

    @publication_categoty = [
      { name: 'monographs', title: t('publication.monographs') },
      { name: 'standard_specification', title: t('publication.standard_specification') },
      { name: 'paper_patent', title: t('publication.paper_patent') },
    ]
  end
end
