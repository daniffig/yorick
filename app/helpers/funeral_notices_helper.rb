module FuneralNoticesHelper
  def format_published_date(date)
    # Spanish month names
    months = {
      1 => 'enero', 2 => 'febrero', 3 => 'marzo', 4 => 'abril',
      5 => 'mayo', 6 => 'junio', 7 => 'julio', 8 => 'agosto',
      9 => 'septiembre', 10 => 'octubre', 11 => 'noviembre', 12 => 'diciembre'
    }

    day = date.day
    month = months[date.month]
    year = date.year

    "Publicado el #{day} de #{month} de #{year}"
  end
end
