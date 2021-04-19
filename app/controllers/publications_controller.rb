# frozen_string_literal: true

class PublicationsController < ApplicationController
  def index
    preview_conf_url = '/pdfjs/web/viewer.html?file=';
    works = Portfolio.order(position: :asc).all
    @works = works.map do |item|
      {
        title: item.title,
        subtitle: item.sub_title,
        cover: item.cover_jpg || item.cover_webp,
        mobile_cover: item.mobile_cover_jpg || item.mobile_cover_webp,
        preview_url: item.pdf_file.present? ? "#{preview_conf_url}#{item.pdf_file}" : '',
        download_url: item.pdf_file.presence || '',
        width: "#{100 * item.pixel_width / 700}%",
        height: "#{100 * item.pixel_height / 900}%",
      }
    end

    publications = Publication.order(position: :asc).all
    @publications = publications.map do |item|
      {
        title: item.title,
        subtitle: item.sub_title,
        cover: item.cover_jpg || item.cover_webp,
        mobile_cover: item.mobile_cover_jpg || item.mobile_cover_webp,
        preview_url: item.pdf_file.present? ? "#{preview_conf_url}#{item.pdf_file}" : '',
        download_url: item.pdf_file.presence || '',
        width: "#{100 * item.pixel_width / 700}%",
        height: "#{100 * item.pixel_height / 900}%",
        category: item.category_status,
      }
    end

    @publication_categoty = [
      { name: 'monographs', title: '专著书籍' },
      { name: 'standard_specification', title: '规范标准' },
      { name: 'paper_patent', title: '论文专利' },
    ]
  end
end
